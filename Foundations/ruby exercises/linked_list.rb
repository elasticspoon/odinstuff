# frozen_string_literal: true

# class of nodes linked together
class LinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    if @head && @tail
      @tail.next_node = Node.new(value)
      @tail = @tail.next_node
    else
      @head = Node.new(value)
      @tail = @head
    end
  end

  def prepend(value)
    if @head && @tail
      @head = Node.new(value, @head)
    else
      @head = Node.new(value)
      @tail = @head
    end
  end

  def size
    return 0 unless @head && @tail

    size_helper(@head)
  end

  def size_helper(current)
    return 0 if current.eql?(nil)

    1 + size_helper(current.next_node)
  end

  def at(index)
    at_helper(index, @head)
  end

  def at_helper(index, node)
    return nil if node.nil?
    return node if index.zero?

    at_helper(index - 1, node.next_node)
  end

  def pop
    if @head.eql?(@tail)
      temp = @head
      @head = nil
      @tail = nil
      return temp
    end
    pop_helper(@head)
  end

  def pop_helper(node)
    if node.next_node.eql?(@tail)
      temp = node.next_node
      node.next_node = nil
      @tail = node
      return temp
    end

    pop_helper(node.next_node)
  end

  def contains?(value)
    find(value) != nil
  end

  def find(value)
    current = @head
    index = 0
    loop do
      return nil unless current
      return index if current.value == value

      current = current.next_node
      index += 1
    end
    nil
  end

  def to_s
    to_s_helper(@head)
  end

  def to_s_helper(node)
    return 'nil' unless node

    "( #{node.value} ) -> " + to_s_helper(node.next_node)
  end

  def insert_at(value, index)
    prepend(value) if index.zero?
    prev_node = at(index - 1)
    return nil if prev_node.nil?

    target_node = prev_node.next_node

    prev_node.next_node = Node.new(value, target_node)
    @tail = prev_node.next_node if target_node.nil?
  end
end

# data holding nodes
class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end

list = LinkedList.new
arr = (0..500).to_a
5.times { list.append(arr.sample) }
puts list.to_s
puts list.at(3).value
puts list.at(2).value
list.insert_at(3, 999)
puts list.to_s
