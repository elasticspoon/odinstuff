# frozen_string_literal: true

# module to add more methods to existing emun module
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given? 

    for k in self do
      yield k
    end
  end

  def my_each_with_index
    accum = 0
    return to_enum(:my_each_with_index) unless block_given? 

    for k in self do
      yield k, accum
      accum += 1
    end
  end

  def my_select
    return self.my_each unless block_given?
    new_arr = []

    for k in self do
      new_arr.push(k) if yield k
    end
    new_arr
  end

  def my_all?(pattern = nil)
    for k in self do
      if block_given? 
        return false unless yield k
      else
        return false unless k === pattern
      end
    end
  end

  def my_any?(pattern = nil)
    for k in self do
      if block_given? 
        return true if yield k
      else
        return true if k === pattern
      end
    end
  end

  def my_none?(pattern = nil)
    return !self.my_any?(pattern)
  end

  def my_count(item = nil)
    accum = 0
    for k in self do 
      accum += 1 unless item || block_given?
      accum += 1 if block_given? && (yield k)
      accum += 1 if item && k === item
    end
    accum
  end
end

puts 'my_each vs each'
nums = [2, 4, 2, 1]
puts nums.my_count
puts nums.my_count(2)
puts nums.my_count { |i| i % 2 == 1}
