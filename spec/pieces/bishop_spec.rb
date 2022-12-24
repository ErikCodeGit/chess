# frozen_string_literal: true

require './lib/pieces/rook'
require './lib/board'

describe Bishop do
  describe '#piece_blocking_move?' do
    let(:board) { Board.new }
    subject(:white_bishop) { board.piece_at([0, 2]) }
    subject(:black_bishop) { board.piece_at([7, 2]) }
    context 'when board is in start position and white bishop tries to move to f4' do
      it 'returns true' do
        expect(white_bishop.piece_blocking_move?([3, 3])).to be(true)
      end
    end

    context 'when board is in start position and black bishop tries to move to e5' do
      it 'returns true' do
        expect(black_bishop.piece_blocking_move?([-3, 3])).to be(true)
      end
    end

    context 'when board is in start position, but pawn c2 is missing and white bishop tries to move to f4' do
      before do
        board.set_piece_at([1, 3], nil)
      end
      it 'returns false' do
        expect(white_bishop.piece_blocking_move?([3, 3])).to be(false)
      end
    end

    context 'when board is in start position, but pawn d7 is missing and black bishop tries to move to e6' do
      before do
        board.set_piece_at([6, 3], nil)
      end
      it 'returns false' do
        expect(black_bishop.piece_blocking_move?([-2, 2])).to be(false)
      end
    end
  end

  describe '#attacked_squares' do
    let(:board) { Board.new }
    subject(:white_bishop) { board.piece_at([0, 2]) }
    subject(:black_bishop) { board.piece_at([7, 2]) }
    context 'when board is in start position' do
      right_squares_white = [[1, 1], [1, 3]]
      right_squares_black = [[6, 1], [6, 3]]
      it 'returns proper array for white rook' do
        expect(white_bishop.attacked_squares).to match_array(right_squares_white)
      end

      it 'returns proper array for black rook' do
        expect(black_bishop.attacked_squares).to match_array(right_squares_black)
      end
    end

    context 'when board is in start position, but pawn is missing' do
      right_squares = [[1, 1], [1, 3], [2, 4], [3, 5], [4, 6], [5, 7]]
      before do
        board.set_piece_at([1, 3], nil)
      end
      it 'returns proper array for white rook' do
        expect(white_bishop.attacked_squares).to match_array(right_squares)
      end
    end

    context 'when board is in start position, but pawn is missing' do
      right_squares = [[6, 1], [6, 3], [5, 4], [4, 5], [3, 6], [2, 7]]
      before do
        board.set_piece_at([6, 3], nil)
      end
      it 'returns proper array for black rook' do
        expect(black_bishop.attacked_squares).to match_array(right_squares)
      end
    end
  end
end
