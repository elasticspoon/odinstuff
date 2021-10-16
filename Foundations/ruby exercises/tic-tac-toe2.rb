class Board
    attr_reader :board

    public
    def initialize
        @empty = Array.new(9) {|i| Piece.new}
        @cross = []
        @circle = []
    end

    

    def play_piece(x, y, piece)
        if piece.downcase == "x" || piece.downcase == "o"
            if @empty.any? {|val| val.coords == [x, y]}
                @empty.reject! {|val| val.coords == [x, y]}
                if piece.downcase == "x"
                    @cross.push(Cross.new(x, y))
                else
                    @circle.push(Circle.new(x,y))
                end
                return true
            end
        end
        false
    end
end

class Piece
    attr_reader :symbol, :coords

    def initialize(x, y)
        @coords = [x, y]
        @symbol = :empty
    end

    def ==(piece)
        return @symbol == piece.symbol
    end

    def to_s
        "."
    end
end

class Cross < Piece
    def initialize(x, y)
        super
        @symbol = :cross
    end

    def to_s
        "X"
    end
end

class Circle < Piece
    def initialize
        super
        @symbol = :circle
    end

    def to_s
        "O"
    end
end

new_board = Board.new()
