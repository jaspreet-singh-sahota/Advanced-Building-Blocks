module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    size = self.size
    while i < size
      is_a?(Range) ? yield(min + i) : yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    idx = 0
    my_each do |elem|
      yield(elem, idx)
      idx += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    if is_a?(Array)
      selected = []
      my_each { |ele| selected << ele if yield ele }
    else
      selected = {}
      my_each { |key, value| selected[key] = value if yield(key, value) }
    end
    selected
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def my_all?(arg = nil, &prc)
    return true if !block_given? && arg.nil? && include?(nil) == false && include?(false) == false
    return false unless block_given? || !arg.nil?

    if block_given?
      my_each { |elem| return false if prc.call(elem) == false }
    elsif arg.class == Regexp
      my_each { |elem| return false if arg.match(elem).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |elem| return false if elem != arg }
    else
      my_each { |elem| return false if (elem.is_a? arg) == false }
    end
    true
  end

  def my_any?(arg = nil, &prc)
    return true if !block_given? && arg.nil? && my_each { |elem| return true if elem == true } && empty? == false
    return false unless block_given? || !arg.nil?

    my_each do |ele|
      return true if prc.call(ele) == true
    end
    false
  end

  def my_none?(arg = nil, &prc)
    !my_any?(arg, &prc)
  end

  def my_count
    count = 0
    my_each do |_|
      count += 1
    end
    count
  end

  def my_map(&prc)
    return enum_for(:map) unless block_given?

    mapped = []
    my_each { |ele| mapped << prc.call(ele) }
    mapped
  end

  def my_inject
    acc = shift
    item_removed = acc
    my_each { |num| acc = yield(acc, num) }
    unshift(item_removed)
    acc
  end
end
# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els
  my_inject { |acc, curr| acc *= curr }
end

puts multiply_els([2, 4, 5]) # => 40
