# frozen_string_literal: false

require 'spec_helper'
require 'rspec'
require './lib/connect_four'

describe GamePiece do
  subject(:test_piece) { described_class.new }
  let(:test_symbol) { 'X' }

  describe '#to_s' do
    before do
      allow(test_piece).to receive(:value).and_return(test_symbol)
      allow(test_piece).to receive(:class).and_return(GamePiece)
    end
    context 'when called on GamePiece' do
      it 'return test symbol value' do
        returned_val = test_piece.to_s
        expect(returned_val).to eql test_symbol
      end
    end
  end

  describe '#==' do
    before do
      allow(test_piece).to receive(:value).and_return(test_symbol)
      allow(test_piece).to receive(:class).and_return(GamePiece)
    end
    context 'when comparing 2 gamepieces' do
      it 'calls values on both' do
        expect(test_piece).to receive(:value).twice
        test_piece == test_piece
      end

      it 'returns true if both have same value' do
        test_piece_comp = test_piece == test_piece
        expect(test_piece_comp).to be true
      end

      let(:diff_piece) { double('circle piece', value: 'O') }
      it 'returns false if different values' do
        value_comparison = test_piece == diff_piece
        expect(value_comparison).to be false
      end

      let(:diff_class_piece) { double('cross piece', value: 'X', class: String) }
      it 'returns true if same value but different class' do
        value_comparison = test_piece == diff_class_piece
        expect(value_comparison).to be true
      end
    end
  end

  describe '#eql?' do
    before do
      allow(test_piece).to receive(:value).and_return(test_symbol)
      allow(test_piece).to receive(:class).and_return(GamePiece)
    end
    context 'when comparing 2 gamepieces' do
      it 'calls values on both' do
        expect(test_piece).to receive(:value).twice
        test_piece.eql?(test_piece)
      end

      it 'calls class on both' do
        expect(test_piece).to receive(:value).twice
        test_piece.eql?(test_piece)
      end

      context 'when both have same value and same class' do
        let(:comp_piece) { double('circle piece', value: test_symbol, class: GamePiece) }
        it do
          value_comparison = test_piece.eql?(comp_piece)
          expect(value_comparison).to be true
        end
      end

      context 'when both have same value and diff class' do
        let(:comp_piece) { double('circle piece', value: test_symbol, class: String) }
        it do
          value_comparison = test_piece.eql?(comp_piece)
          expect(value_comparison).to be false
        end
      end

      context 'when have different value same class' do
        let(:comp_piece) { double('circle piece', value: 'O', class: GamePiece) }
        it do
          value_comparison = test_piece.eql?(comp_piece)
          expect(value_comparison).to be false
        end
      end

      context 'when have diff val, diff class' do
        let(:comp_piece) { double('circle piece', value: 'O', class: String) }
        it do
          value_comparison = test_piece.eql?(comp_piece)
          expect(value_comparison).to be false
        end
      end
    end
  end

  describe '#winning_piece' do
    context 'when called on a piece' do
      it 'changes piece value to W' do
        expect { test_piece.winning_piece }.to change { test_piece.value }.to('W')
      end
    end
  end
end

describe GameBoard do
  subject(:test_board) { described_class.new }
  let(:test_width) { 7 }
  let(:test_height) { 6 }

  describe '#create_empty_board' do
    context 'when given test_width and test_height' do
      it 'changes @board' do
        expect do
          test_board.create_empty_board(test_width, test_height)
        end.to change { test_board.board }
      end

      it 'board is test_width arrays of test_height size' do
        new_board = test_board.board
        array_height = new_board.length
        array_widths = new_board.map(&:length)
        expect(array_height).to eq test_height
        expect(array_widths).to all(eq test_width)
      end

      it 'starts all GamePiece' do
        new_board = test_board.board
        new_board.each do |arr|
          expect(arr).to all(eq GamePiece.new)
        end
      end
    end
  end

  describe '#set_piece' do
    let(:small_board) { Array.new(3) { Array.new(4) { GamePiece.new } } }
    context 'when piece location valid' do
      it 'changes piece at location' do
        allow(test_board).to receive(:board).and_return(small_board)
        diff_piece = CrossPiece.new
        set_return = test_board.set_piece(0, 1, diff_piece)
        location = test_board.board[0][1]
        expect(set_return).to be_truthy
        expect(location).to eq diff_piece
      end
    end

    context 'when piece location invalid' do
      let(:small_board) { [[GamePiece.new], [CrossPiece.new]] }
      before do
        allow(test_board).to receive(:board).and_return(small_board)
        allow(test_board).to receive(:width).and_return(1)
        allow(test_board).to receive(:height).and_return(2)
      end
      it 'returns false if spot is taken' do
        set_piece = test_board.set_piece(1, 0, CrossPiece.new)
        expect(set_piece).to be false
      end

      it 'returns false if spot not in range' do
        out_of_range_val = 7
        set_piece = test_board.set_piece(out_of_range_val, out_of_range_val, CrossPiece.new)
        expect(set_piece).to be false
      end
    end
  end

  describe '#get_first_open' do
    before do
      allow(test_board).to receive(:get_col).and_return(test_col)
    end
    context 'when column full' do
      let(:test_col) { Array.new(3) { CrossPiece.new } }
      it 'returns nil' do
        first_open = test_board.get_first_open(0)
        expect(first_open).to be_nil
      end
    end

    context 'when column has space' do
      context 'when column empty' do
        let(:test_col) { Array.new(3) { GamePiece.new } }
        it 'returns 0' do
          correct_index = 0
          expect(test_board.get_first_open(1)).to eq correct_index
        end
      end
      context 'when column has some pieces' do
        let(:test_col) { [CrossPiece.new, CrossPiece.new, GamePiece.new] }
        it 'returns 2' do
          correct_index = 2
          expect(test_board.get_first_open(1)).to eq correct_index
        end
      end
    end
  end

  describe '#valid_rc?' do
    let(:small_board) { Array.new(3) { Array.new(4) { GamePiece.new } } }
    let(:test_width) { 4 }
    let(:test_height) { 7 }
    before do
      allow(test_board).to receive(:width).and_return(test_width)
      allow(test_board).to receive(:height).and_return(test_height)
    end

    context 'when valid row valid col' do
      it { expect(test_board.valid_rc?(1, 1)).to be true }
    end

    context 'when valid row invalid col' do
      it { expect(test_board.valid_rc?(1, -8)).to be false }
    end

    context 'when invalid row valid col' do
      it { expect(test_board.valid_rc?(99, 2)).to be false }
    end

    context 'when valid row no col' do
      it { expect(test_board.valid_rc?(1)).to be true }
    end

    context 'when no row valid col' do
      it { expect(test_board.valid_rc?(nil, 1)).to be true }
    end

    context 'when invalid row no col' do
      it { expect(test_board.valid_rc?(16)).to be false }
    end
  end

  describe '#get_row' do
    let(:small_board) { Array.new(3) { Array.new(4) { GamePiece.new } } }
    before do
      allow(test_board).to receive(:board).and_return(small_board)
      allow(test_board).to receive(:width).and_return(4)
      allow(test_board).to receive(:height).and_return(4)
    end

    it 'returns the correct row' do
      correct_row = Array.new(4) { CrossPiece.new }
      small_board.push(correct_row)
      returned_row = test_board.get_row(3)
      expect(returned_row).to eq correct_row
    end

    it 'calls valid_rc?' do
      expect(test_board).to receive(:valid_rc?)
      test_board.get_row(1)
    end
  end

  describe '#get_col' do
    let(:test_col) { Array.new(4) { CirclePiece.new } }
    let(:small_board) { (Array.new(3) { Array.new(4) { GamePiece.new } }).push(test_col).transpose }

    before do
      allow(test_board).to receive(:board).and_return(small_board)
      allow(test_board).to receive(:width).and_return(4)
      allow(test_board).to receive(:height).and_return(4)
    end

    it 'returns the correct row' do
      returned_row = test_board.get_col(3)
      expect(returned_row).to eq test_col
    end

    it 'calls valid_rc?' do
      expect(test_board).to receive(:valid_rc?)
      test_board.get_col(3)
    end
  end

  describe '#get_diag' do
    let(:small_board) do
      [
        [CirclePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new, CirclePiece.new],
        [CrossPiece.new, CirclePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new],
        [GamePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new, CirclePiece.new],
        [GamePiece.new, GamePiece.new, GamePiece.new, GamePiece.new, GamePiece.new]
      ]
    end

    before do
      allow(test_board).to receive(:board).and_return(small_board)
      allow(test_board).to receive(:width).and_return(4)
      allow(test_board).to receive(:height).and_return(5)
      allow(test_board).to receive(:get_diag_helper)
    end

    context 'when given coordinates it calls helper function on closest point of diag to (0, 0) corner' do
      it 'calls helper(0, 0) on (0,0)' do
        expect(test_board).to receive(:get_diag_helper).with(0, 0, 5, small_board)
        test_board.get_diag(0, 0)
      end

      it 'calls helper(0, 0) on (4,4)' do
        expect(test_board).to receive(:get_diag_helper).with(0, 0, 5, small_board)
        test_board.get_diag(4, 4)
      end

      it 'calls helper(2, 0) on (3,1)' do
        expect(test_board).to receive(:get_diag_helper).with(0, -2, 5, small_board)
        test_board.get_diag(3, 1)
      end

      it 'calls helper(0, 4) on (0,4)' do
        expect(test_board).to receive(:get_diag_helper).with(-4, 0, 5, small_board)
        test_board.get_diag(0, 4)
      end
    end

    it 'reverses the board if is_up arg is false' do
      expect(test_board).to receive(:get_diag_helper).with(-4, 0, 5, small_board.reverse)
      test_board.get_diag(0, 4, is_up: false)
    end
  end

  describe '#get_diag_helper' do
    let(:small_board) do
      [
        [CirclePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new, CirclePiece.new],
        [CrossPiece.new, CirclePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new],
        [GamePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new, CirclePiece.new],
        [GamePiece.new, GamePiece.new, GamePiece.new, GamePiece.new, GamePiece.new]
      ]
    end

    before do
      allow(test_board).to receive(:width).and_return(4)
      allow(test_board).to receive(:height).and_return(5)
    end

    context 'when asked for diag returns correct diag' do
      it 'gets diag starting at (0,0)' do
        expected_array = [CirclePiece.new, CirclePiece.new, CirclePiece.new, GamePiece.new]
        returned_array = test_board.get_diag_helper(0, 0, 5, small_board)
        expect(returned_array).to eql expected_array
      end

      it 'gets diag starting at (0,2)' do
        expected_array = [CirclePiece.new, CirclePiece.new, CirclePiece.new]
        returned_array = test_board.get_diag_helper(0, 2, 5, small_board)
        expect(returned_array).to eql expected_array
      end

      it 'gets diag starting at (2,0)' do
        expected_array = [GamePiece.new, GamePiece.new]
        returned_array = test_board.get_diag_helper(2, 0, 5, small_board)
        expect(returned_array).to eql expected_array
      end

      it 'gets diag starting at (5,5)' do
        expected_array = []
        returned_array = test_board.get_diag_helper(5, 5, 5, small_board)
        expect(returned_array).to eql expected_array
      end
    end
  end

  describe '#get_piece' do
    let(:small_board) do
      [
        [CirclePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new, CirclePiece.new],
        [CrossPiece.new, CirclePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new],
        [GamePiece.new, CrossPiece.new, CirclePiece.new, GamePiece.new, CirclePiece.new],
        [GamePiece.new, GamePiece.new, GamePiece.new, GamePiece.new, GamePiece.new]
      ]
    end

    before do
      allow(test_board).to receive(:board).and_return(small_board)
      allow(test_board).to receive(:width).and_return(4)
      allow(test_board).to receive(:height).and_return(5)
    end
    it 'calls valid_rc' do
      expect(test_board).to receive(:valid_rc?)
      test_board.get_piece(2, 1)
    end

    it 'returns the correct piece' do
      expected_piece = CrossPiece.new
      returned_piece = test_board.get_piece(2, 1)
      expect(returned_piece).to eql(expected_piece)
    end
  end

  describe '#check_win' do
    context 'when given an array XXXXOOOOXXXOOO' do
      let(:test_array) do
        [1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2].map { |i| i == 1 ? CrossPiece.new : CirclePiece.new }
      end
      it 'first X returns a win' do
        first_x = test_array[0]
        returned_result = test_board.check_win(test_array, first_x)
        expect(returned_result).to be true
      end
      it 'second X returns a loss' do
        second_x = test_array[8]
        returned_result = test_board.check_win(test_array, second_x)
        expect(returned_result).to be false
      end
      it 'first O returns a win' do
        first_o = test_array[4]
        returned_result = test_board.check_win(test_array, first_o)
        expect(returned_result).to be true
      end
      it 'second O returns a loss' do
        second_o = test_array[12]
        returned_result = test_board.check_win(test_array, second_o)
        expect(returned_result).to be false
      end
    end
  end

  describe '#winning_move?' do
    context 'when given a piece' do
      it 'returns false if the piece is not circle or cross' do
        expect(test_board.winning_move?(4, 5, GamePiece.new)).to be false
      end

      it 'calls get_row, get_col, get_diag twice' do
        allow(test_board).to receive_messages(get_row: [], get_col: [], get_diag: [], check_win: false)
        expect(test_board).to receive(:get_row)
        expect(test_board).to receive(:get_col)
        expect(test_board).to receive(:get_diag).twice
        expect(test_board).to receive(:check_win).exactly(4).times
        test_board.winning_move?(3, 4, CrossPiece.new)
      end

      it 'returns true if check win true' do
        allow(test_board).to receive_messages(get_row: [], get_col: [], get_diag: [], check_win: false)
        expect(test_board.winning_move?(4, 5, CrossPiece.new))
      end
    end
  end

  describe '#play_piece' do
    it 'calls set_piece, winning_move?' do
      allow(test_board).to receive_messages(set_piece: true, winning_move?: true, get_first_open: 1)
      expect(test_board).to receive(:set_piece)
      expect(test_board).to receive(:winning_move?)
      expect(test_board).to receive(:get_first_open)
      test_board.play_piece(3, CrossPiece.new)
    end

    it 'returns false if get_first_open is nil' do
      allow(test_board).to receive_messages(set_piece: true, winning_move?: true, get_first_open: nil)
      expect(test_board.play_piece(5, CrossPiece.new)).to be false
    end
    it 'returns false if set_piece false' do
      allow(test_board).to receive_messages(set_piece: false, winning_move?: true, get_first_open: 1)
      expect(test_board.play_piece(5, CrossPiece.new)).to be false
    end
    it 'returns "win" if winning_move? is true' do
      allow(test_board).to receive_messages(set_piece: true, winning_move?: true, get_first_open: 1)
      expect(test_board.play_piece(3, CrossPiece.new)).to eq 'win'
    end
    it 'returns true if piece is set' do
      allow(test_board).to receive_messages(set_piece: true, winning_move?: false, get_first_open: 1)
      expect(test_board.play_piece(2, CrossPiece.new)).to be true
    end
  end

  describe 'to_s' do
    let(:small_board) { [[GamePiece.new, CrossPiece.new], [CrossPiece.new, CirclePiece.new]] }
    it 'returns string of the board' do
      allow(test_board).to receive(:board).and_return(small_board)
      expected_string = "X O\n_ X"
      returned_string = test_board.to_s
      expect(returned_string).to eq expected_string
    end
  end
end

describe ConnectFour do
  subject(:test_game) { described_class.new }

  describe '#user_input' do
    it 'returns expected value' do
      allow(test_game).to receive(:gets).and_return('9')
      expected_val = 9
      expect(test_game).to receive(:puts)
      returned_val = test_game.user_input
      expect(returned_val).to eq expected_val
    end

    it 'if invlid input loops til valid' do
      allow(test_game).to receive(:gets).and_return('j', 'u', '6')
      allow(test_game).to receive(:puts)
      expect(test_game).to receive(:gets).exactly(3).times
      test_game.user_input
    end
  end

  describe 'start game' do
    before do
      allow(test_game).to receive_messages(start_text: nil, game: some_game, win: nil, puts: nil)
      allow(test_game).to receive(:try_turn).and_return(false, true, 'win')
    end

    let(:some_game) { double('to_s_game', to_s: '') }

    it 'calls start_text, try_turn, to_s and win once' do
      expect(test_game).to receive(:start_text)
      expect(test_game).to receive(:try_turn)
      expect(some_game).to receive(:to_s)
      expect(test_game).to receive(:win)
      test_game.start_game
    end

    context 'when try_turn false' do
      before do
        allow(test_game).to receive(:try_turn).and_return(false, false, 'win')
      end
      it 'loops back to try turn' do
        expect(test_game).to receive(:try_turn).exactly(3).times
        test_game.start_game
      end

      it 'does not change player turn' do
        expect { test_game.start_game }.to_not change { test_game.player_one }
      end
    end

    context 'when try_turn is true it' do
      before do
        allow(test_game).to receive(:try_turn).and_return(true, true, 'win')
      end
      it 'loops back to try turn' do
        expect(test_game).to receive(:try_turn).exactly(3).times
        test_game.start_game
      end
      it 'changes player turn' do
        expect { test_game.start_game }.to_not change { test_game.player_one }
      end
    end
  end
end
