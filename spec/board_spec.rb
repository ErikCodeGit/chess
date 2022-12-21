# frozen_string_literal: true

require './lib/board'
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
  describe '#move_piece' do
    context 'when moving a pawn from a2 to a3' do
      it 'moves the pawn to a3' do
        a2_parsed = board_class.parse_coordinates('a2')
        a3_parsed = board_class.parse_coordinates('a3')
        board.move_piece(a2_parsed, a3_parsed)
        expect(board.piece_at(a3_parsed)).to be_kind_of(Pawn)
      end
    end

    context 'when moving a pawn from a7 to a6' do
      it 'moves the pawn to a6' do
        a6_parsed = board_class.parse_coordinates('a6')
        a7_parsed = board_class.parse_coordinates('a7')
        board.move_piece(a7_parsed, a6_parsed)
        expect(board.piece_at(a6_parsed)).to be_kind_of(Pawn)
      end
    end
  end
end
