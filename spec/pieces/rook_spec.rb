# frozen_string_literal: true

require './lib/pieces/rook'
require './lib/board'

describe Rook do
  describe '#piece_blocking_move?' do
    let(:board) { Board.new }
    subject(:white_rook) { board.piece_at([0, 0]) }
    subject(:black_rook) { board.piece_at([7, 0]) }
    context 'when board is in start position and white rook tries to move 3 up' do
      it 'returns true' do
        expect(white_rook.piece_blocking_move?([3, 0])).to be(true)
      end
    end

    context 'when board is in start position and black rook tries to move 3 down' do
      it 'returns true' do
        expect(black_rook.piece_blocking_move?([-3, 0])).to be(true)
      end
    end

    context 'when board is in start position, but pawn is missing and white rook tries to move 3 down' do
      before do
        board.set_piece_at([1, 0], nil)
      end
      it 'returns false' do
        expect(white_rook.piece_blocking_move?([3, 0])).to be(false)
      end
    end

    context 'when board is in start position, but pawn is missing and black rook tries to move 3 down' do
      before do
        board.set_piece_at([6, 0], nil)
      end
      it 'returns false' do
        expect(black_rook.piece_blocking_move?([-3, 0])).to be(false)
      end
    end
  end

  describe '#attacked_squares' do
    let(:board) { Board.new }
    subject(:white_rook) { board.piece_at([0, 0]) }
    subject(:black_rook) { board.piece_at([7, 0]) }
    context 'when board is in start position' do
      right_squares_white = [[1, 0], [0, 1]]
      right_squares_black = [[6, 0], [7, 1]]
      it 'returns proper array for white rook' do
        expect(white_rook.attacked_squares).to match_array(right_squares_white)
      end

      it 'returns proper array for black rook' do
        expect(black_rook.attacked_squares).to match_array(right_squares_black)
      end
    end

    context 'when board is in start position, but pawn is missing' do
      right_squares = [[0, 1], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]]
      before do
        board.set_piece_at([1, 0], nil)
      end
      it 'returns proper array for white rook' do
        expect(white_rook.attacked_squares).to match_array(right_squares)
      end
    end

    context 'when board is in start position, but pawn is missing' do
      right_squares = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 1]]
      before do
        board.set_piece_at([6, 0], nil)
      end
      it 'returns proper array for black rook' do
        expect(black_rook.attacked_squares).to match_array(right_squares)
      end
    end
  end
end
