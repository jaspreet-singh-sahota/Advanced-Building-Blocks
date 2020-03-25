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
end