# frozen_string_literal: true

# module to add more methods to existing emun module
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given? 

    for k, v in self do
      yield self.is_a?(Hash) ? [k, v] : k
    end
  end

  def my_each_with_index
    accum = 0
    return self.my_each unless block_given? 

    for k in self do
      yield k, accum
      accum += 1
    end
  end

  def my_select
    return self.my_each unless block_given?
    new_arr = []
    new_hash = {}

    for k, v in self do
      if self.is_a?(Hash) && (yield k, v)
        new_hash[k] = v 
      elsif self.is_a?(Array) && (yield k)
        new_arr.push(k)
      end
    end
    return self.is_a?(Hash) ? new_hash : new_arr
  end

  def my_all?(*pattern, &block)
    for k in self do
      return false if block && !(block.call(k))
      return false if !pattern.empty? && !(pattern[0] === k)
      return false if !k
    end
    true
  end

  def my_any?(*pattern, &block)
    for k in self do
      return true if block && (block.call(k))
      return true if !pattern.empty? && (pattern[0] === k)
      return true if k
    end
    false
  end

  def my_none?(*pattern, &block)
    return !self.my_any?(pattern, &block)
  end

  def my_count(*pattern, &block)
    accum = 0
    for k in self do 
      accum += 1 if pattern.empty? && !block
      accum += 1 if block && (yield k)
      accum += 1 if !pattern.empty? && pattern[0].eql?(k)
    end
    accum
  end

  def my_map
    return self.my_each unless block_given?
    arr = []
    for k in self do
      arr.push(yield k)
    end
    arr
  end

  def my_map_proc(some_proc)
    return self.my_each unless some_proc
    arr = []
    for k in self do
      arr.push(some_proc.call(k))
    end
    arr
  end

  def my_map_proc_block(*some_proc, &block)
    return self.my_each if some_proc.empty? && !block
    arr = []
    for k in self do
      if !some_proc.empty?
        arr.push(some_proc[0].call(k))
        next
      end
      arr.push(block.call(k))
    end
    arr
  end

  def my_inject(*args, &block)
    memo =  (block || args.length == 2) ? args[0] : nil
    for k in self do
      if !memo 
        memo = k 
        next
      end 
      memo = block.call(memo, k) if block
      memo = args.last.to_proc.call(memo, k) unless block
    end
    memo
  end
end


hash = {a: "hi", b: "bye"}
arr  = [1, 2, 3, 4]
some_proc = Proc.new {|i| i * i}
other_proc = Proc.new { "cat"}
puts "mine"
puts arr.my_map_proc_block(some_proc).inspect
puts arr.my_map_proc_block(other_proc).inspect
puts (arr.my_map_proc_block {|i| i * i}).inspect
puts (arr.my_map_proc_block { "cat"}).inspect
puts (arr.my_map_proc_block(some_proc) {|i| i * i}).inspect
puts (arr.my_map_proc_block(other_proc) { "cat"}).inspect
puts "real"

