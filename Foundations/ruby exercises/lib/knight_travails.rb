# frozen_string_literal: true

# class representing the knight piece
class Knight
  def initialize; end
end

# graph that represents all possible moves of the knight
class ChessBoard
  attr_accessor :graph, :distance, :prev

  def initialize
    @graph = {}
    fill_graph
  end

  def fill_graph
    possible_starts = (0...8).to_a.repeated_permutation(2).to_a
    possible_starts.each do |x, y|
      @graph[[x, y]] = get_moves(x, y)
    end
  end

  def get_moves(x, y)
    movement_directions = [-2, -1, 1, 2].permutation(2).to_a.filter { |val| val[0].abs != val[1].abs }
    possible_moves = movement_directions.map { |val| [val[0] + x, val[1] + y] }
    possible_moves.filter { |val| (0...8).include?(val[0]) && (0...8).include?(val[1]) }
  end

  def find_min_dist(arr)
    distances = arr.map { |val| @distance[val] }
    shortest_d = distances.min
    index = distances.find_index(shortest_d)
    arr[index]
  end

  def get_vertex_set(source)
    knight_start = []
    @distance = {}
    @prev = {}
    @graph.each_key do |vertex|
      @distance[vertex] = Float::INFINITY
      @prev[vertex] = nil
      knight_start.push(vertex)
    end
    @distance[source] = 0
    knight_start
  end

  def adjust_lengths(unvisted_v)
    @graph[unvisted_v].each do |vertex|
      temp = @distance[unvisted_v] + 1
      if temp < @distance[vertex]
        @distance[vertex] = temp
        @prev[vertex] = unvisted_v
      end
    end
  end

  def shortest_distance(source, target)
    knight_start = get_vertex_set(source)
    loop do
      break if knight_start.empty?

      unvisted_v = knight_start.delete(find_min_dist(knight_start))
      return unvisted_v if unvisted_v == target

      adjust_lengths(unvisted_v)
    end
  end

  def get_shortest_dist(source, target)
    shortest_distance(source, target)
    sd_helper(source, target)
  end

  def sd_helper(source, target, arr = [])
    if source == target
      puts "Here's your path:"
      return arr.unshift(source)
    end
    sd_helper(source, @prev[target], arr.unshift(target))
  end
end

board = ChessBoard.new
puts board.get_shortest_dist([3, 3], [4, 3]).inspect
