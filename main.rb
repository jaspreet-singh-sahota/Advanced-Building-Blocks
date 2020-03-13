module Enumerable
    def my_each(&prc)
        idx = 0
        while idx < self.length
            if self.kind_of?(Array)
                yield self[idx]
            elsif prc.arity == 1
                yield(assoc keys[idx])
            else
                yield(keys[idx], self[keys[idx]])
            end
            idx +=1
        end
        self
    end
    
    def my_each_with_index
        idx = 0
        while idx < self.length
            yield(self[idx], idx)
            idx +=1
        end
        self
    end

    def my_select
        if self.kind_of?(Array)
            selected = []
            my_each { |ele| selected << ele if yield ele}
        else
            selected = {}
            my_each { |key, value| selected[key] = value if yield(key, value) }
        end
        selected
    end

    def my_all?(&prc)
        my_each do |ele|
            if prc.call(ele) == false
                return false
            end
        end
        true
    end

    def my_any?(&prc)
        my_each do |ele|
            if prc.call(ele) == true
                return true
            end
        end
        false
    end

    def my_none?(&prc)
        my_each do |ele|
            if prc.call(ele) == true
                return false
            end
        end
        true
    end

    def my_count
        count = 0
        my_each do |ele|
            count+=1
        end
        count
    end

    def my_map(&prc)
        mapped = []
        my_each {|ele| mapped << prc.call(ele)}
        mapped
    end

    def my_inject
		acc = self.shift # [1,2,3,4,5]
		item_removed = acc # 1
		self.my_each { |num| acc = yield(acc, num) }
		self.unshift(item_removed)
		acc
    end

    def multiply_els
	self.my_inject { |acc, curr| acc *= curr }
    end
end
