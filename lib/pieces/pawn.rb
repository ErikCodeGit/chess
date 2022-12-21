# frozen_string_literal: true

require './lib/pieces/piece'
class Pawn < Piece
  def valid_move?(move)
    if taking_pattern.include?(move)
      can_take?(move)
    else
      (normal_move?(move) || double_move?(move)) && !piece_blocking_move?(move)
    end
  end

  def piece_blocking_move?(move)
    @board.pieces_in_column(@position, add(@position, move)).all?(&:nil?)
  end

  def can_take?(move)
    return false unless taking_pattern.include?(move)

    @board.piece_at(add(@position, move)).color == opposite_color(@color)
  end

  def taking_pattern
    case @color
    when :white
      [[-1, 1], [1, 1]]
    when :black
      [[-1, -1], [1, -1]]
    end
  end

  def normal_move?(move)
    (@color == :white && move == [0, 1]) ||
      (@color == :black && move == [0, -1])
  end

  def double_move?(move)
    (!@moved && @color == :white && move == [0, 2]) ||
      (!@moved && @color == :black && move == [0, -2])
  end
end
