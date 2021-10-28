# frozen_string_literal: true

# class that plays connect four game
class ConnectFour
  attr_reader :game, :player_one

  def initialize
    @game = GameBoard.new
    @player_one = true
  end

  def user_input
    loop do
      puts 'Choose a digit between 0 and 9'
      guess = gets.chomp
      return guess.to_i if guess.match(/^[0-9]$/)
    end
    false
  end

  def win
    puts 'Wow! You won.'
  end

  def start_text
    puts "Connect four rules:\n"
  end

  def try_turn
    puts game.to_s
    puts player_one ? 'Player one turn.' : 'Player two turn.'
    input = user_input
    game.play_piece(input, player_one ? CrossPiece.new : CirclePiece.new)
  end

  def start_game
    start_text
    loop do
      result = try_turn
      case result
      when 'win'
        return win
      when false
        puts 'Invalid column.'
        next
      else
        @player_one = !@player_one
        game.to_s
      end
    end
  end
end

# class that hold peices and does logic for checking game state
# and pieces getting played
class GameBoard
  attr_reader :width, :height, :board

  NUM_TO_WIN = 4

  def initialize(width = 6, height = 7)
    @width = width
    @height = height
    create_empty_board(width, height)
  end

  def create_empty_board(width, height)
    @board = Array.new(width) { Array.new(height) { GamePiece.new } }
  end

  def set_piece(row, col, piece)
    return false unless (0...width).include?(row) && (0...height).include?(col)

    temp = board[row][col]
    return false unless temp.value.nil?

    board[row][col] = piece
  end

  def valid_rc?(row = nil, col = nil)
    return true if col.nil? && (0...width).include?(row)
    return true if row.nil? && (0...height).include?(col)
    return true if (0...width).include?(row) && (0...height).include?(col)

    false
  end

  def get_first_open(col)
    array = get_col(col)
    return nil if array.nil?

    array.index(GamePiece.new)
  end

  def get_col(col_num)
    return board.transpose[col_num] if valid_rc?(nil, col_num)
  end

  def get_row(row_num)
    return board[row_num] if valid_rc?(row_num)
  end

  def get_diag(row, column, is_up: true)
    longest_dist = [row, column].max
    start_row = row - longest_dist
    start_col = column - longest_dist
    diag_len = [width, height].max

    get_diag_helper(start_row, start_col, diag_len, is_up ? board : board.reverse)
  end

  def get_diag_helper(row, col, length, array)
    accum = []
    length.times do |i|
      cur_r = row + i
      cur_c = col + i
      target_p = valid_rc?(cur_r, cur_c) ? array[cur_r][cur_c] : nil
      accum.push(target_p)
    end
    accum.compact
  end

  def get_piece(row, col)
    board[row][col] if valid_rc?(row, col)
  end

  def check_win(array, piece)
    array.each_cons(NUM_TO_WIN) do |sub_arr|
      next unless sub_arr.any? { |val| val.equal?(piece) }
      return true if sub_arr.all? { |val| val == piece }
    end
    false
  end

  def winning_move?(row, col, piece)
    return true if check_win(get_row(row), piece)
    return true if check_win(get_col(col), piece)
    return true if check_win(get_diag(row, col), piece)
    return true if check_win(get_diag(row, col, is_up: false), piece)

    false
  end

  def play_piece(col, piece)
    row = get_first_open(col)
    return false unless !row.nil? && set_piece(row, col, piece)
    return 'win' if winning_move?(row, col, piece)

    true
  end

  def to_s
    rows_to_s = board.map do |arr|
      arr.map { |i| i.to_s == '' ? '_' : i.to_s }.join(' ')
    end
    rows_to_s.reverse.join("\n")
  end
end

# class that describes the pieces connect 4 is played with
class GamePiece
  attr_reader :value

  def to_s
    value.to_s
  end

  def ==(other)
    value == other.value
  end

  def eql?(other)
    self.==(other) && (self.class == other.class)
  end

  def winning_piece
    @value = 'W'
  end
end

# GanePiece with 'X' for symbol
class CrossPiece < GamePiece
  def initialize
    super
    @value = 'X'
  end
end

# GanePiece with 'O' for symbol
class CirclePiece < GamePiece
  def initialize
    super
    @value = 'O'
  end
end

# game = ConnectFour.new
# game.start_game
