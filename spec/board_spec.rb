# frozen_string_literal: true

require './lib/board'
require './lib/player'
require './lib/constants'
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }

describe Board do
  subject(:board_class) { described_class }
  describe '::parse_coordinates' do
    context 'when given a8' do
      it 'returns [7, 0]' do
        expect(board_class.parse_coordinates('a8')).to eq([7, 0])
      end
    end

    context 'when given f1' do
      it 'returns [0, 6]' do
        expect(board_class.parse_coordinates('f1')).to eq([0, 5])
      end
    end

    context 'when given c5' do
      it 'returns [4, 2]' do
        expect(board_class.parse_coordinates('c5')).to eq([4, 2])
      end
    end
  end

  subject(:board) { described_class.new }
  let(:pablo) { Player.new(:white, 1, 'Pablo') }
  let(:gus) { Player.new(:black, 2, 'Gus') }
  describe '#move_piece' do
    context 'when moving a pawn from a2 to a3' do
      it 'moves the pawn to a3' do
        a2_parsed = board_class.parse_coordinates('a2')
        a3_parsed = board_class.parse_coordinates('a3')
        board.move_piece(a2_parsed, a3_parsed, pablo)
        expect(board.piece_at(a3_parsed).is_a?(Pawn)).to be(true)
      end
    end

    context 'when moving a pawn from a7 to a6' do
      it 'moves the pawn to a6' do
        a6_parsed = board_class.parse_coordinates('a6')
        a7_parsed = board_class.parse_coordinates('a7')
        board.move_piece(a7_parsed, a6_parsed, gus)
        expect(board.piece_at(a6_parsed).is_a?(Pawn)).to be(true)
      end
    end
  end

  describe '#pieces_in_column' do
    subject(:board) { described_class.new }
    context 'when two black pawns are ahead of a white pawn' do
      before do
        board.set_piece_at([2, 0], Pawn.new(:black, [2, 0], board))
        board.set_piece_at([3, 0], Pawn.new(:black, [3, 0], board))
      end
      it 'return an array with two black pawns' do
        expect(board.pieces_in_column([1, 0], [3, 0]).count { |piece| piece.is_a?(Pawn) }).to eq(2)
      end
    end
  end
end
