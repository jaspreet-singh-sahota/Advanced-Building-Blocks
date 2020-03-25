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
    my_each do |ele|
      yield(ele, idx)
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
      my_each { |ele| return false if prc.call(ele) == false }
    elsif arg.class == Regexp
      my_each { |ele| return false if arg.match(ele).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |ele| return false if ele != arg }
    else
      my_each { |ele| return false if (ele.is_a? arg) == false }
    end
    true
  end

  def my_any?(arg = nil, &prc)
    return true if !block_given? && arg.nil? && my_each { |ele| return true if ele == true } && empty? == false
    return false unless block_given? || !arg.nil?

    if block_given?
      my_each { |ele| return true if prc.call(ele) }
    elsif arg.class == Regexp
      my_each { |ele| return true unless arg.match(ele).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |ele| return true if ele == arg }
    else
      my_each { |ele| return true if ele.class <= arg }
    end
    false
  end

  def my_none?(arg = nil, &prc)
    !my_any?(arg, &prc)
  end

  def my_count(arg = nil, &prc)
    count = 0
    my_each do |ele|
      if block_given?
        count += 1 if prc.call(ele)
      elsif !arg.nil?
        count += 1 if ele == arg
      else
        count = length
      end
    end
    count
  end

  def my_map(prc = nil)
    return enum_for(:map) unless block_given?

    mapped = []
    my_each { |ele| mapped << prc.call(ele) } if block_given? && prc
    my_each { |ele| mapped << yield(ele) } if prc.nil?
    mapped
  end

  def my_inject(memo = nil, sym = nil, &prc)
    memo = memo.to_sym if memo.is_a?(String) && !sym && !prc

    if memo.is_a?(Symbol) && !sym
      prc = memo.to_proc
      memo = nil
    end

    sym = sym.to_sym if sym.is_a?(String)
    prc = sym.to_proc if sym.is_a?(Symbol)

    my_each { |ele| memo = memo.nil? ? ele : prc.yield(memo, ele) }
    memo
  end
end

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(arr)
  arr.my_inject { |acc, curr| acc *= curr }
end

puts multiply_els([2, 4, 5]) # => 40
