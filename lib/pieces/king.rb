# frozen_string_literal: true

require './lib/pieces/piece'
class King < Piece
  def in_check?; end

  def valid_moves
    movement_pattern.each do |move|
      add(move, @position) if valid_move?(move)
    end
  end

  def valid_move?(move)
    !((@board.piece_at(add(move,
                           @position)).color == @color) || piece_blocking_move?(move) || @board.attacked_square?(add(
                                                                                                                   move, @position
                                                                                                                 )))
  end

  def movement_pattern
    [[1, - 1], [1, 0], [1, 1],
     [0, -1],           [0, 1],
     [-1, -1], [-1, 0], [-1, 1]]
  end

  def piece_blocking_move?
    false
  end
end
