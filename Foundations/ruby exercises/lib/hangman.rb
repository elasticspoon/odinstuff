require 'json'

class HangMan
  attr_reader :tries, :word, :current_guess

  def initialize
    set_random_word
    @tries = 8
  end

  def set_random_word
    dict = File.open('5desk.txt') if File.exist? '5desk.txt'
    word_list = dict.readlines
    @word = word_list.sample.downcase.chars
    @current_guess = Array.new(@word.length - 1) { '_' }
  end

  def display_guess
    puts @current_guess.join(' ')
  end

  def display_word
    puts @word.join(' ')
  end

  def make_guess(letter)
    @word.each_with_index do |l, i|
      @current_guess[i] = letter.downcase if letter.downcase == l
    end
    @tries -= 1
  end

  def to_JSON(io)
    JSON.dump({
                tries: @tries,
                current_guess: @current_guess,
                word: @word
              }, io)
  end

  def save_game
    save = File.open('save.sav', 'w')
    to_JSON(save)
  end

  def load_game
    saved_game = File.open('save.sav') if File.exist? 'save.sav'
    first_line = saved_game.readline
    parsed_data = JSON.parse(first_line)
    @tries = parsed_data['tries']
    @current_guess = parsed_data['current_guess']
    @word = parsed_data['word']
  end
end
