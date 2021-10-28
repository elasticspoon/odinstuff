# frozen_string_literal: false

require 'spec_helper'
require 'rspec'
require './lib/tic-tac-toe'

describe Piece do
  subject(:some_piece) { described_class.new }

  describe '#==' do
    context 'when some_piece and target_piece have same symbol' do
      let(:target_piece) { instance_double(Piece, symbol: '.') }
      it 'returns true' do
        piece_target_comparison = some_piece == target_piece
        expect(piece_target_comparison).to be true
      end
    end

    context 'when some_piece and target_piece have different symbols' do
      let(:target_piece) { instance_double(Piece, symbol: 'X') }
      it 'returns false' do
        piece_target_comparison = some_piece == target_piece
        expect(piece_target_comparison).to be false
      end
    end
  end

  describe '#to_s' do
    before do
      allow(some_piece).to receive(:to_s)
    end

    it 'returns the symbol of the piece' do
      generic_piece_symbol = '.'
      expect(some_piece).to receive(:to_s).and_return(generic_piece_symbol)
      some_piece.to_s
    end
  end
end

describe Board do
  subject(:testing_board) { described_class.new }
  let(:current_game) { Array.new(3) { Array.new(3) { Piece.new } } }

  describe '#to_s' do
    before do
      allow(testing_board).to receive(:board).and_return(current_game)
    end
    context 'when empty board' do
      it 'returns ...
              ...
              ...' do
        empty_board_string =
          "...\n...\n...\n"
        expect(testing_board.to_s).to eql empty_board_string
      end
    end

    context 'when it has a row of Cross' do
      let(:current_game) do
        [Array.new(3) { Cross.new }, Array.new(3) { Piece.new }, Array.new(3) { Piece.new }]
      end
      it 'orients row horizontaly' do
        board_with_top_row_cross = "XXX\n...\n...\n"
        expect(testing_board.to_s).to eql board_with_top_row_cross
      end
    end

    context 'when it has a colmun' do
      let(:current_game) { Array.new(3) { [Cross.new, Piece.new, Piece.new] } }
      it 'orients row vertically' do
        board_with_top_row_cross = "X..\nX..\nX..\n"
        expect(testing_board.to_s).to eql board_with_top_row_cross
      end
    end
  end

  describe '#get_piece' do
  end

  describe '#play_piece' do
  end

  describe '#full?' do
  end

  describe '#get_column' do
    before do
      allow(testing_board).to receive(:board).and_return(current_game)
    end
    context 'when given valid column number' do
      let(:expected_col_one_contents) { [Cross.new, Circle.new, Piece.new] }
      let(:current_game) { [Array.new(3), expected_col_one_contents, Array.new(3)].transpose }
      it 'returns an array of column contents' do
        valid_col_number = 1
        col_one_contents = testing_board.get_column(valid_col_number)
        expect(col_one_contents).to eq expected_col_one_contents
      end
    end

    context 'when given invalid column number' do
      it do
        invalid_col_number = 8
        expect(testing_board.get_column(invalid_col_number)).to be nil
      end
    end
  end

  describe '#get_row' do
    before do
      allow(testing_board).to receive(:board).and_return(current_game)
    end

    context 'when given valid row number' do
      let(:expected_row_one_contents) { [Cross.new, Circle.new, Piece.new] }
      let(:current_game) { [[], expected_row_one_contents, []] }
      it 'returns an array of row contents' do
        valid_row_number = 1
        row_one_contents = testing_board.get_row(valid_row_number)
        expect(row_one_contents).to eq expected_row_one_contents
      end
    end

    context 'when given invalid row number' do
      it do
        invalid_row_number = 8
        expect(testing_board.get_row(invalid_row_number)).to be nil
      end
    end
  end

  describe '#get_diag_up' do
  end

  describe '#get_diag_down' do
  end

  describe '#check_win' do
  end

  describe '#edit_winning_symbols' do
  end

  describe '#check_spot' do
  end
end
