# frozen_string_literal: true

require './lib/pieces/piece'
class Knight < Piece
  def valid_move?(move)
    return false if move_out_of_bounds?(move)

   (movement_pattern.include?(move) &&
      (!piece_blocking_move?(move) || can_take?(move))) && !expose_king_to_mate?(move)
  end

  def movement_pattern
    [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
  end

  def attacked_squares
    all_visible_squares
  end

  def all_visible_squares
    movement_pattern.reject { |move|  move_out_of_bounds?(move) }.map { |move| add(@position, move) }
  end

  def piece_blocking_move?(move)
    position_after_move = add(@position, move)
    piece_at_position_after_move = @board.piece_at(position_after_move)
    !piece_at_position_after_move.nil?
  end

  def can_take?(move)
    position_after_move = add(@position, move)
    piece_at_position_after_move = @board.piece_at(position_after_move)
    return false if piece_at_position_after_move.nil?

    piece_at_position_after_move.color == opposite_color(@color)
  end
end
