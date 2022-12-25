# frozen_string_literal: true

require './lib/pieces/piece'
class King < Piece
  def valid_move?(move)
    return false if move_out_of_bounds?(move)
    return false if suicide?(move) || expose_king_to_mate?(move)

    movement_pattern.include?(move) &&
      (!piece_blocking_move?(move) || can_take?(move))
  end

  def movement_pattern
    [[1, - 1], [1, 0], [1, 1],
     [0, -1],           [0, 1],
     [-1, -1], [-1, 0], [-1, 1]]
  end

  def piece_blocking_move?(move)
    position_after_move = add(@position, move)
    piece_at_position_after_move = @board.piece_at(position_after_move)
    !piece_at_position_after_move.nil?
  end

  def attacked_squares
    all_visible_squares
  end

  def all_visible_squares
    movement_pattern.map { |move| add(@position, move) }.delete_if { |move| move_out_of_bounds?(move) }
  end

  def can_take?(move)
    position_after_move = add(@position, move)
    piece_at_position_after_move = @board.piece_at(position_after_move)
    return false if piece_at_position_after_move.nil?

    piece_at_position_after_move.color == opposite_color(@color)
  end

  def in_check?
    case @color
    when :white
      @board.white_king_in_check?
    when :black
      @board.black_king_in_check?
    end
  end

  def suicide?(move)
    case @color
    when :white
      @board.squares_attacked_by_black.include?(add(@position, move))
    when :black
      @board.squares_attacked_by_white.include?(add(@position, move))
    end
  end
end
