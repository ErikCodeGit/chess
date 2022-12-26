# frozen_string_literal: true

require './lib/pieces/pawn'
require './lib/board'
describe Pawn do
  describe '#normal_move?' do
    let(:board) { double(Board) }
    subject(:white_pawn) { described_class.new(:white, [1, 0], board) }
    context 'when a white pawn tries to move 1 up' do
      it 'returns true' do
        expect(white_pawn.normal_move?([1, 0])).to be(true)
      end
    end

    context 'when a white pawn tries to move 3 up' do
      it 'returns false' do
        expect(white_pawn.normal_move?([3, 0])).to be(false)
      end
    end

    subject(:black_pawn) { described_class.new(:black, [6, 0], board) }
    context 'when a black pawn tries to move 1 down' do
      it 'returns true' do
        expect(black_pawn.normal_move?([-1, 0])).to be(true)
      end
    end

    context 'when a black pawn tries to move 2 down, 2 right' do
      it 'returns false' do
        expect(black_pawn.normal_move?([-2, 2])).to be(false)
      end
    end
  end

  describe '#double_move?' do
    let(:board) { double(Board) }
    subject(:white_pawn) { described_class.new(:white, [1, 0], board) }
    context "when white pawn hasn't moved yet and tries to move 2 up" do
      it 'returns true' do
        expect(white_pawn.double_move?([2, 0])).to be(true)
      end
    end

    context 'when white pawn has moved and tries to move 2 up' do
      before do
        white_pawn.instance_variable_set(:@moved, true)
      end
      it 'returns false' do
        expect(white_pawn.double_move?([2, 0])).to be(false)
      end
    end

    subject(:black_pawn) { described_class.new(:black, [6, 0], board) }
    context "when black pawn hasn't moved yet and tries to move 2 down" do
      it 'returns true' do
        expect(black_pawn.double_move?([-2, 0])).to be(true)
      end
    end

    context 'when black pawn has moved and tries to move 2 down' do
      before do
        black_pawn.instance_variable_set(:@moved, true)
      end
      it 'returns false' do
        expect(black_pawn.double_move?([-2, 0])).to be(false)
      end
    end
  end

  describe '#can_take?' do
    before do
      board.set_up_board
    end
    context 'when white pawn is 1 below and left of black pawn' do
      let(:board) { Board.new }
      subject(:white_pawn) { described_class.new(:white, [1, 0], board) }
      subject(:black_pawn) { described_class.new(:black, [2, 1], board) }
      before do
        board.set_piece_at([2, 1], black_pawn)
      end
      it 'returns true' do
        expect(white_pawn.can_take?([1, 1])).to be(true)
      end
    end

    context 'when white pawn has no enemy pieces ahead' do
      let(:board) { Board.new }
      subject(:white_pawn) { board.piece_at([1, 0]) }
      it 'returns false' do
        expect(white_pawn.can_take?([1, 1])).to be(false)
      end
    end

    context 'when black pawn is 1 above and right of black pawn' do
      let(:board) { Board.new }
      subject(:white_pawn) { described_class.new(:white, [1, 0], board) }
      subject(:black_pawn) { described_class.new(:black, [2, 1], board) }
      before do
        board.set_piece_at([2, 1], black_pawn)
      end
      it 'returns true' do
        expect(black_pawn.can_take?([-1, -1])).to be(true)
      end
    end

    context 'when black pawn has no enemy pieces ahead' do
      let(:board) { Board.new }
      subject(:black_pawn) { board.piece_at([6, 2]) }
      it 'returns false' do
        expect(black_pawn.can_take?([-1, -1])).to be(false)
      end
    end
  end

  describe '#valid_move?' do
    let(:board) { Board.new }
    before do
      board.set_up_board
    end
    subject(:white_pawn) { board.piece_at([1, 0]) }
    subject(:black_pawn) { described_class.new(:black, [2, 1], board) }
    context 'when white pawn is in start position and black pawn up-right' do
      context 'when white pawn tries to take' do
        before do
          board.set_piece_at([2, 1], black_pawn)
        end
        it 'returns true' do
          expect(white_pawn.valid_move?([1, 1])).to be(true)
        end
      end

      context 'when white pawn tries to move 1 up' do
        before do
          board.set_piece_at([2, 1], black_pawn)
        end
        it 'returns true' do
          expect(white_pawn.valid_move?([1, 0])).to be(true)
        end
      end

      context 'when black pawn tries to take' do
        before do
          board.set_piece_at([2, 1], black_pawn)
        end
        it 'returns true' do
          expect(black_pawn.valid_move?([-1, -1])).to be(true)
        end
      end

      context 'when black pawn tries to move 1 down' do
        before do
          board.set_piece_at([2, 1], black_pawn)
        end
        it 'returns false' do
          expect(black_pawn.valid_move?([-1, 0])).to be(false)
        end
      end
    end
  end

  describe '#piece_blocking_move?' do
    let(:board) { Board.new }
    before do
      board.set_up_board
    end
    subject(:white_pawn) { board.piece_at([1, 0]) }
    subject(:black_pawn) { described_class.new(:black, [2, 0], board) }
    context 'when there is a black pawn in front of a white pawn and white pawn tries to move 1 up' do
      it 'returns false' do
        expect(white_pawn.piece_blocking_move?([1, 0])).to be(false)
      end
    end
    context 'when there is a black pawn in front of a white pawn and black pawn tries to move 1 down' do
      it 'returns true' do
        expect(black_pawn.piece_blocking_move?([-1, 0])).to be(true)
      end
    end
  end
end
