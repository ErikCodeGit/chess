# frozen_string_literal: true

require './lib/pieces/piece'
class Pawn < Piece
  def valid_move?(move)
    return false if move_out_of_bounds?(move)

    if taking_pattern.include?(move)
      can_take?(move)
    else
      (normal_move?(move) || double_move?(move)) && !piece_blocking_move?(move)
    end && !expose_king_to_mate?(move)
  end

  def piece_blocking_move?(move)
    pieces_along_move = @board.pieces_in_column(@position, add(@position, move))
    return false if pieces_along_move.nil?

    pieces_along_move.any? { |piece| !piece.nil? }
  end

  def can_take?(move)
    return false unless taking_pattern.include?(move)

    piece_at_new_position = @board.piece_at(add(@position, move))
    return false if piece_at_new_position.nil?

    piece_at_new_position.color == opposite_color(@color)
  end

  def attacked_squares
    all_visible_squares
  end

  def all_visible_squares
    result = []
    taking_pattern.each do |move|
      next if move_out_of_bounds?(move)

      result << add(@position, move)
    end
    result
  end

  def taking_pattern
    case @color
    when :white
      [[1, -1], [1, 1]]
    when :black
      [[-1, -1], [-1, 1]]
    end
  end

  def movement_pattern
    case @color
    when :white
      if @moved
        [[1, -1], [1, 0], [1, 1]]
      else
        [[1, -1], [1, 0], [1, 1], [2, 0]]
      end
    when :black
      if @moved
        [[-1, -1], [-1, 0], [-1, 1]]
      else
        [[-1, -1], [-1, 0], [-1, 1], [-2, 0]]
      end
    end
  end

  def normal_move?(move)
    (@color == :white && move == [1, 0]) ||
      (@color == :black && move == [-1, 0])
  end

  def double_move?(move)
    (!@moved && @color == :white && move == [2, 0]) ||
      (!@moved && @color == :black && move == [-2, 0])
  end
end
