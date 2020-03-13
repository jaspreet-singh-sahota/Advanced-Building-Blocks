module Enumerable
  def my_each(&prc)
    i = 0
    while i < length
      if is_a?(Array)
        yield self[i]
      elsif prc.arity == 1
        yield(assoc keys[i])
      else
        yield(keys[i], self[keys[i]])
      end
      i += 1
    end
    self
  end

  def my_each_with_index
    idx = 0
    while idx < length
      yield(self[idx], idx)
      idx += 1
    end
    self
  end

  def my_select
    if is_a?(Array)
      selected = []
      my_each { |ele| selected << ele if yield ele }
    else
      selected = {}
      my_each { |key, value| selected[key] = value if yield(key, value) }
    end
    selected
  end

  def my_all?(&prc)
    my_each do |ele|
      return false if prc.call(ele) == false
    end
    true
  end

  def my_any?(&prc)
    my_each do |ele|
      return true if prc.call(ele) == true
    end
    false
  end

  def my_none?(&prc)
    my_each do |ele|
      return false if prc.call(ele) == true
    end
    true
  end

  def my_count
    count = 0
    my_each do |_|
      count += 1
    end
    count
  end

  def my_map(&prc)
    mapped = []
    my_each { |ele| mapped << prc.call(ele) }
    mapped
  end

  def my_inject
    acc = shift # [1,2,3,4,5]
    item_removed = acc # 1
    my_each { |num| acc = yield(acc, num) }
    unshift(item_removed)
    acc
  end

  def multiply_els
    my_inject { |acc, curr| acc *= curr }
  end
end
