class Game
  attr_reader :board, :last_turn

  def initialize
    @board = Board.new
    @last_turn = 'X'
  end

  def start_game
    loop do
      @board.print_board_state
      puts "You are #{@last_turn}. Select a row, column location to play #{@last_turn}"
      input = get_user_turn
      break if input.nil?
      next if input == false

      result = @board.player_turn(input[0], input[1], @last_turn == 'X' ? Cross.new : Circle.new)
      if result.nil?
        @board.print_board_state
        puts "OMG #{@last_turn} won!"
        break
      end
      next if result == false

      @last_turn = @last_turn == 'X' ? 'O' : 'X'
      next unless result == 'tie'

      @board.print_board_state
      puts 'OMG its a tie.'
      break
    end
  end

  private

  def get_user_turn
    puts 'Gimme a row 0 to 2. Enter q to quit.'
    row = gets.downcase.chomp
    puts 'Gimme a column 0 to 2. Enter q to quit.'
    col = gets.downcase.chomp
    if row == 'q' || col == 'q'
      nil
    elsif (0..2).include?(row.to_i) && (0..2).include?(col.to_i)
      [row.to_i, col.to_i]
    else
      false
    end
  end
end

class Board
  attr_reader :board, :rows, :columns

  def initialize(rows = 3, columns = 3, _cons_to_win = 3)
    @board = Array.new(rows) { Array.new(columns) { Piece.new } }
    @rows = rows
    @columns = columns
  end

  def player_turn(row, col, piece)
    return false unless play_piece(row, col, piece)
    return nil if edit_winning_symbols(check_spot(row, col))
    return 'tie' if full?

    true
  end

  def print_board_state
    puts to_s
  end

  def get_piece(row, col)
    return @board[row][col] if (0..@rows - 1).include?(row) && (0..@columns - 1).include?(col)

    false
  end

  def play_piece(row, column, piece)
    if get_piece(row, column) && get_piece(row, column).symbol == '.'
      @board[row][column] = piece
      true
    else
      false
    end
  end

  def full?
    @board.none? do |i|
      i.any? { |j| j.symbol == '.' }
    end
  end

  def check_spot(r, c)
    piece = get_piece(r, c)
    return false unless piece

    check_win(get_row(r), piece) ||
      check_win(get_column(c), piece) ||
      check_win(get_diag_up(r, c), piece) ||
      check_win(get_diag_down(r, c), piece)
  end

  def get_column(column)
    board.map { |row| row[column] }
  end

  def get_row(row)
    board[row]
  end

  def get_diag_up(row, column)
    accum = []
    row -= [row, column].max
    column -= [row, column].max
    len = [rows, columns].max

    len.times do |i|
      accum.push(get_piece(row + i, column + i))
    end
    accum.filter { |i| i }
  end

  def get_diag_down(row, column)
    accum = []
    val = [row, columns - 1 - column].min
    row += val
    column -= val
    len = [rows, columns].max

    len.times { |i| accum.push(get_piece(row - i, column + i)) }
    accum.filter { |i| i }
  end

  def check_win(array, symbol)
    array.each_cons(3).any? do |arr|
      return arr if arr.any? { |item| symbol.equal?(item) } && arr.all? { |item| symbol == item }
    end
    false
  end

  def edit_winning_symbols(arr)
    if arr
      arr.each { |i| i.symbol = 'W' }
      arr
    else
      false
    end
  end

  def to_s
    accum = ''
    board.each do |arr|
      accum += arr.reduce('') { |acc, val| acc += val.to_s }
      accum += "\n"
    end
    accum
  end
end

class Piece
  attr_accessor :symbol

  def initialize
    @symbol = '.'
  end

  def ==(other)
    @symbol == other.symbol
  end

  def to_s
    @symbol
  end
end

class Cross < Piece
  def initialize
    @symbol = 'X'
  end
end

class Circle < Piece
  def initialize
    @symbol = 'O'
  end
end
