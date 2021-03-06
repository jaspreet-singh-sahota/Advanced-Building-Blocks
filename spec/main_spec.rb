require './main.rb'

RSpec.describe Enumerable do
  let(:arr) { [1, 2, 3, 4, 5] }
  let(:arr_regex) { %w[cat bat rat hello] }
  let(:arr_nil) { [1, nil, false] }
  let(:match_arr) { [1, 1, 1] }
  let(:arr_empty) { [] }
  let(:arr_count) { [1, 1, 1, 2, 3] }

  describe '#my_each' do
    it 'should return Enumerator if block is not given' do
      expect(arr.my_each).to be_a(Enumerator)
      expect(arr.my_each.to_a).to eq(arr)
    end

    it 'should not use the built-in Array#each' do
      expect(arr).to_not receive(:each)
    end

    it 'should work as #each method if block given' do
      expect(arr.my_each { |ele| puts "return: #{ele}" }).to eq(arr.each { |ele| puts "return: #{ele}" })
    end

    it 'should take 0 arguments' do
      expect { arr.my_each('argument') }.to raise_error(ArgumentError)
      expect { arr.my_each }.not_to raise_error(ArgumentError)
    end
  end

  describe '#my_each_with_index' do
    it 'should return Enumerator if block is not given' do
      expect(arr.my_each_with_index).to be_a(Enumerator)
    end

    it 'should not use the built-in Array#select' do
      expect(arr).to_not receive(:each_with_index)
    end

    it 'should work as #each_with_index method if block given' do
      # rubocop:disable Layout/LineLength
      expect(arr.my_each_with_index { |ele, index| puts "#{ele} : #{index}" }).to eq(arr.each_with_index { |ele, index| puts "#{ele} : #{index}" })
      # rubocop:enable Layout/LineLength
    end

    it 'should take 0 arguments' do
      expect { arr.my_each_with_index('argument') }.to raise_error(ArgumentError)
      expect { arr.my_each_with_index }.not_to raise_error(ArgumentError)
    end
  end

  describe '#my_select' do
    arr_even = [3, 2, 3, 4]
    arr_odd = [1, 5, 6, 11, 13]
    odd = [11, 13]
    arr = [3, 5, 'A', 'B']

    it 'should not use the built-in Array#select' do
      expect(arr).to_not receive(:select)
    end

    it 'should return Enumerator if block is not given' do
      expect(arr_even.my_select).to be_a(Enumerator)
    end

    it 'should return empty Array if no elements matches' do
      expect(arr.my_select { |ele| ele == 'x' }).to eq([])
    end

    it 'should take 0 argumets' do
      expect { arr.my_select('argument') }.to raise_error(ArgumentError)
      expect { arr.my_select }.not_to raise_error(ArgumentError)
    end
    it 'when Array given should return an Array' do
      expect(arr_even.my_select(&:even?)).to be_an(Array)
    end

    it 'when Array given should return an Array with selected elements' do
      expect(arr_odd.my_select(&:odd?)).to eq([1, 5, 11, 13])
    end
  end

  describe '#my_all?' do
    it 'should not use the built-in Array#none?' do
      expect(arr).to_not receive(:all?)
    end

    it 'returns true if at least one of the element is not false or nil' do
      expect(arr_nil.my_any?(1)).to eq(true)
    end

    it 'returns true if all of the element is a member of such class' do
      expect(arr.my_all?(Integer)).to eq(true)
    end

    it 'returns true if all of the element matches the pattern' do
      expect(match_arr.my_all?(1)).to eq(true)
    end

    it 'should return true if all elements matches the block condition' do
      expect(arr_regex.my_all? { |ele| ele.length >= 3 }).to eq(true)
    end

    it 'should return true if empty arr is given' do
      expect(arr_empty.my_all?).to eq(true)
    end
  end

  describe '#my_any?' do
    it 'should not use the built-in Array#none?' do
      expect(arr).to_not receive(:none?)
    end

    it 'should return true if at least one of the element is not false or nil' do
      expect(arr_nil.my_any?(1)).to eq(true)
    end

    it 'should return true if at least one of the element is a member of such class' do
      expect(arr_nil.my_any?(Integer)).to eq(true)
    end

    it 'should return false if none of the element matches the Regex' do
      expect(arr_regex.my_any?(/z/)).not_to eq(true)
    end

    it 'should return false if none of the element matches the pattern' do
      expect(arr.my_any?(1)).to eq(true)
    end

    it 'should return true if any elements matches the block condition' do
      expect(arr_regex.my_any? { |ele| ele.length >= 3 }).to eq(true)
    end

    it 'if empty arr is given should return false' do
      expect(arr_empty.my_any?).not_to eq(true)
    end
  end

  describe '#my_none?' do
    it 'should not use the built-in Array#none?' do
      expect(arr).to_not receive(:none?)
    end

    it 'should return true if none of the element members is true' do
      expect(arr.my_none?).not_to eq(true)
    end

    it 'should return true if none of the element is a member of such class' do
      expect(arr.my_none?(String)).to eq(true)
    end

    it 'should return true only if none of the element matches the Regex' do
      expect(arr.my_none?(2)).not_to eq(true)
    end

    it 'should return true only if none of the element matches the pattern' do
      expect(arr.my_none?(4)).not_to eq(true)
    end

    it 'should return true if none elements matches the block condition' do
      expect(arr_regex.my_none? { |ele| ele.length >= 3 }).to eq(false)
    end

    it 'should return true if empty arr is given' do
      expect(arr_empty.my_none?).to eq(true)
    end
  end

  describe '#count' do
    it 'should not use the built-in Array#none?' do
      expect(arr).to_not receive(:count)
    end

    it 'should return the number of items in element through enumeration' do
      expect(arr.my_count).to eq(5)
    end

    it 'should count the number of items in element that are equal to item' do
      expect(arr_count.my_count(1)).to eq(3)
    end

    it 'should return number of elements that matches the condition' do
      expect(arr.my_count(&:odd?)).to eq(3)
    end
  end

  describe '#my_map' do
    it 'should accept an arr and a block as args' do
      expect { my_map([1, 2, 3]) { |n| 2 * n } }.to_not raise_error(ArgumentError)
    end

    it 'should return to Enumerator if block is not given' do
      expect(arr.my_each).to be_a(Enumerator)
    end

    it 'if block given should return new arr matching the conditions' do
      expect(arr.my_map { |elem| elem + 3 }).to eq([4, 5, 6, 7, 8])
    end

    it 'should execute the proc when both a proc and a block are given' do
      my_proc = proc { |num| num > 2 }
      expect(arr.my_map(my_proc) { |num| num > 2 }).to eq([false, false, true, true, true])
    end

    it 'should not use the built-in Array#map' do
      expect(arr).to_not receive(:map)
    end
  end

  describe '#my_inject' do
    it 'should not use the built-in Array#map' do
      expect(arr).to_not receive(:my_inject)
    end

    it 'should combine each element of the collection by applying the symbol when a symbol is specified' do
      expect(arr.my_inject('+')).to eq(15)
    end

    it 'should combine each element of the collection by applying the, symbol when a symbol is specified' do
      expect((5..10).my_inject(2, :*)).to eq(302_400)
    end

    it 'when block given should return the result of the block' do
      expect((5..10).my_inject(4) { |prod, n| prod * n }).to eq(604_800)
    end
  end

  describe 'multiply_els' do
    it 'should multiply all the elements of the arr together by using #my_inject method' do
      expect(multiply_els([2, 4, 5])).to eql(40)
    end
  end
end
