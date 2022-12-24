require './lib/pieces/knight'
require './lib/board'

describe Knight do
  describe '#valid_move?' do
    let(:board) { Board.new }
    subject(:white_knight) { board.piece_at([0, 1])}
    subject(:black_knight) { board.piece_at([7, 1])}
    context 'on a starting board' do
      it 'returns true for white knight b1 -> c3' do
        expect(white_knight.valid_move?([2, 1])).to be(true)
      end
      it 'returns true for white knight b1 -> a3' do
        expect(white_knight.valid_move?([2, -1])).to be(true)
      end

      it 'returns true for black knight b8 -> c6' do
        expect(black_knight.valid_move?([-2, 1])).to be(true)
      end
      it 'returns true for black knight b8 -> a6' do
        expect(black_knight.valid_move?([-2, -1])).to be(true)
      end
    end
  end
end