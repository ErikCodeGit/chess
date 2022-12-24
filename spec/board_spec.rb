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

  describe '#pieces_in_ascending_diagonal' do
    subject(:board) { described_class.new }
    context 'on a start board' do
      context 'when calling from c1 to f4' do
        it 'returns an array with a white pawn and bishop' do
          correct_array = [board.piece_at([0, 2]), board.piece_at([1, 3])]
          expect(board.pieces_in_ascending_diagonal([0, 2], [3, 5]).compact).to match_array(correct_array)
        end
      end

      context 'when calling from a1 to h8' do
        it 'returns an array with a white rook, pawn, black pawn, rook' do
          correct_array = [board.piece_at([0, 0]), board.piece_at([1, 1]), board.piece_at([6, 6]),
                           board.piece_at([7, 7])]
          expect(board.pieces_in_ascending_diagonal([0, 0], [7, 7]).compact).to match_array(correct_array)
        end
      end
    end
  end

  describe '#pieces_in_descending_diagonal' do
    subject(:board) { described_class.new }
    context 'on a start board' do
      context 'when calling from c8 to e6' do
        it 'returns an array with a black pawn and bishop' do
          correct_array = [board.piece_at([7, 2]), board.piece_at([6, 3])]
          expect(board.pieces_in_descending_diagonal([7, 2], [5, 4]).compact).to match_array(correct_array)
        end
      end

      context 'when calling from a8 to h1' do
        it 'returns an array with a black rook, pawn, white pawn, rook' do
          correct_array = [board.piece_at([7, 0]), board.piece_at([6, 1]), board.piece_at([1, 6]),
                           board.piece_at([0, 7])]
          expect(board.pieces_in_descending_diagonal([7, 0], [0, 7]).compact).to match_array(correct_array)
        end
      end
    end
  end

  describe '#generate_row_moves' do
    subject(:board) { described_class.new }
    context 'when generating the row with [0, 0]' do
      it 'returns the normal coordinates in row' do
        normal_row = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
        expect(board.generate_row_moves([0, 0])).to eq(normal_row)
      end
    end

    context 'when generating the row with [1, 1]' do
      it 'returns the right moves' do
        shifted_row = [[0, -1], [0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6]]
        expect(board.generate_row_moves([1, 1])).to eq(shifted_row)
      end
    end
  end

  describe '#generate_column_moves' do
    subject(:board) { described_class.new }
    context 'when generating the column with [0, 0]' do
      it 'returns the normal coordinates in row' do
        normal_column = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
        expect(board.generate_column_moves([0, 0])).to eq(normal_column)
      end
    end

    context 'when generating the column with [1, 1]' do
      it 'returns the right moves' do
        shifted_column = [[-1, 0], [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]]
        expect(board.generate_column_moves([1, 1])).to eq(shifted_column)
      end
    end
  end

  describe '#generate_ascending_diagonal_moves' do
    subject(:board) { described_class.new }
    context 'when generating the diagonal with [0, 0]' do
      it 'returns the normal coordinates in diagonal' do
        normal_diagonal = [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
        expect(board.generate_ascending_diagonal_moves([0, 0])).to match_array(normal_diagonal)
      end
    end

    context 'when generating the column with [1, 1]' do
      it 'returns the right moves' do
        shifted_diagonal = [[-1, -1], [0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6]]
        expect(board.generate_ascending_diagonal_moves([1, 1])).to match_array(shifted_diagonal)
      end
    end

    context 'when generating the column with [1, 0]' do
      it 'returns the right moves' do
        shifted_diagonal = [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6]]
        expect(board.generate_ascending_diagonal_moves([1, 0])).to match_array(shifted_diagonal)
      end
    end

    context 'when generating the column with [3, 6]' do
      it 'returns the right moves' do
        shifted_diagonal = [[-3, -3], [-2, -2], [-1, -1], [0, 0], [1, 1]]
        expect(board.generate_ascending_diagonal_moves([3, 6])).to match_array(shifted_diagonal)
      end
    end

    context 'when generating the column with [6, 3]' do
      it 'returns the right moves' do
        shifted_diagonal = [[-3, -3], [-2, -2], [-1, -1], [0, 0], [1, 1]]
        expect(board.generate_ascending_diagonal_moves([6, 3])).to match_array(shifted_diagonal)
      end
    end
  end

  describe '#generate_descending_diagonal_moves' do
    subject(:board) { described_class.new }
    context 'when generating the diagonal with [7, 0]' do
      it 'returns the normal coordinates in diagonal' do
        normal_diagonal = [[0, 0], [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]]
        expect(board.generate_descending_diagonal_moves([7, 0])).to match_array(normal_diagonal)
      end
    end

    context 'when generating the column with [1, 1]' do
      it 'returns the right moves' do
        shifted_diagonal = [[1, -1], [0, 0], [-1, 1]]
        expect(board.generate_descending_diagonal_moves([1, 1])).to match_array(shifted_diagonal)
      end
    end

    context 'when generating the column with [1, 0]' do
      it 'returns the right moves' do
        shifted_diagonal = [[0, 0], [-1, 1]]
        expect(board.generate_descending_diagonal_moves([1, 0])).to match_array(shifted_diagonal)
      end
    end

    context 'when generating the column with [3, 6]' do
      it 'returns the right moves' do
        shifted_diagonal = [[4, -4], [3, -3], [2, -2], [1, -1], [0, 0], [-1, 1]]
        expect(board.generate_descending_diagonal_moves([3, 6])).to match_array(shifted_diagonal)
      end
    end

    context 'when generating the column with [6, 3]' do
      it 'returns the right moves' do
        shifted_diagonal = [[1, -1], [0, 0], [-1, 1], [-2, 2], [-3, 3], [-4, 4]]
        expect(board.generate_descending_diagonal_moves([6, 3])).to match_array(shifted_diagonal)
      end
    end
  end
end
