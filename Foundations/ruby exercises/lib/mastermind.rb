class MasterMind

    attr_reader :code, :tries_left

    def initialize(tries = 8)
        set_rand_code
        @tries_left = tries
    end

    def set_code(input)
        @code = parse_code(input)
    end

    def set_rand_code
        @code = (1..6).to_a.sample(4)
    end

    def parse_code(input)
        input.chars.map(&:to_i)
    end

    def check_code(guess, code_attempt = @code)
        return [get_black_pegs(code_attempt, guess), get_white_pegs(code_attempt, guess)]
    end

    def get_black_pegs(arr_code, arr_guess)
        return arr_code.zip(arr_guess).reduce(0){|accum, i| accum = accum + (i[0] == i[1] ? 1 : 0)}
    end
    
    def get_white_pegs(arr_code, arr_guess)
        return arr_code.length - 
         [(arr_code - arr_guess).length, (arr_guess - arr_code).length].max -
         get_black_pegs(arr_code, arr_guess)
    end

    def computer_solve
        guesses = (1..6).to_a.repeated_permutation(4).to_a
        current_guess = [1, 1, 2, 2]
        loop do
            val = check_code(current_guess)
            if val[0] == 4
                puts "got " + current_guess.map(&:to_s).join("")
                break
            end
            puts "tried #{current_guess.map(&:to_s).join("")}. "
            guesses = guesses.filter {|i| check_code(i, current_guess) == val}
            current_guess = guesses.pop
        end
    end
end


game = MasterMind.new(8)

code = [5, 4, 2, 1]
guess = [1, 1, 2, 2]
guess2 = [1, 1, 2, 4]

=begin 
puts game.check_code(guess) 
puts
puts game.check_code([5, 4, 2, 1], guess) 
puts
puts game.check_code(guess, guess) 
=end

game.computer_solve