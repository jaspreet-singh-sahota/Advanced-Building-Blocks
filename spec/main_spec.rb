require './main.rb'

RSpec.describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5] }
  let(:arr_regex) { %w[cat bat rat hello] }
  let(:arr_nil) { [1, nil, false] }
  let(:match_arr) { [1, 1, 1] }
  let(:arr_empty) { [] }
  let(:arr_count) { [1, 1, 1, 2, 3] }

  describe '#my_each' do
    it 'should return Enumerator if block is not given' do
      expect(array.my_each).to be_a(Enumerator)
      expect(array.my_each.to_a).to eq(array)
    end

    it "should not use the built-in Array#each" do
      expect(array).to_not receive(:each)
    end

    it 'should work as #each method if block given' do
      expect(array.my_each { |ele| puts "return: #{ele}" }).to eq(array.each { |ele| puts "return: #{ele}" })
    end

    it 'should take 0 arguments' do
      expect { array.my_each('argument') }.to raise_error(ArgumentError)
      expect { array.my_each }.not_to raise_error(ArgumentError)
    end
  end

  describe '#my_each_with_index' do
    it 'should return Enumerator if block is not given' do
      expect(array.my_each_with_index).to be_a(Enumerator)
    end

    it "should not use the built-in Array#select" do
      expect(array).to_not receive(:each_with_index)
    end

    it 'should work as #each_with_index method if block given' do
      # rubocop:disable Layout/LineLength
      expect(array.my_each_with_index { |ele, index| puts "#{ele} : #{index}" }).to eq(array.each_with_index { |ele, index| puts "#{ele} : #{index}" })
      # rubocop:enable Layout/LineLength
    end

    it 'should take 0 arguments' do
      expect { array.my_each_with_index('argument') }.to raise_error(ArgumentError)
      expect { array.my_each_with_index }.not_to raise_error(ArgumentError)
    end
  end

  describe '#my_select' do
    arr_even = [3, 2, 3, 4] 
    arr_odd = [1, 5, 6, 11, 13] 
    odd = [11, 13] 
    array = [3, 5, 'A', 'B'] 

    it "should not use the built-in Array#select" do
      expect(array).to_not receive(:select)
    end

    it 'should return Enumerator if block is not given' do
      expect(arr_even.my_select).to be_a(Enumerator)
    end
    
    it 'should return empty Array if no elements matches' do
      expect(array.my_select { |ele| ele == 'x' }).to eq([])
    end

    it 'should take 0 argumets' do
      expect { array.my_select('argument') }.to raise_error(ArgumentError)
      expect { array.my_select }.not_to raise_error(ArgumentError)
    end
    it 'when Array given should return an Array' do
      expect(arr_even.my_select(&:even?)).to be_an(Array)
    end

    it 'when Array given should return an Array with selected elements' do
      expect(arr_odd.my_select(&:odd?)).to eq([1, 5, 11, 13])
    end
  end

  describe '#my_all?' do
    it 'returns true if at least one of the element is not false or nil' do
      expect(arr_nil.my_any?(1)).to eq(true)
    end

    it 'returns true if all of the element is a member of such class' do
      expect(array.my_all?(Integer)).to eq(true)
    end

    it 'returns true if all of the element matches the pattern' do
      expect(match_arr.my_all?(1)).to eq(true)
    end

    it 'should return true if all elements matches the block condition' do
      expect(arr_regex.my_all? { |ele| ele.length >= 3 }).to eq(true)
    end

    it 'should return true if empty array is given' do
      expect(arr_empty.my_all?).to eq(true)
    end
  end
end