# frozen_string_literal: true

require './lib/pieces/piece'
class King < Piece
  def valid_move?(move)
    return false if move_out_of_bounds?(move)

    (((movement_pattern - castling_pattern).include?(move) &&
      (!piece_blocking_move?(move) || can_take?(move))) ||
      (!piece_blocking_move?(move) && can_castle?(move))) && !(suicide?(move) || expose_king_to_mate?(move))
  end

  def movement_pattern
    [[1, - 1], [1, 0], [1, 1],
     [0, -1],           [0, 1],
     [-1, -1], [-1, 0], [-1, 1]] | castling_pattern
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
    (movement_pattern - castling_pattern).delete_if { |move| move_out_of_bounds?(move) }.map do |move|
      add(@position, move)
    end
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

  def castling_pattern
    [[0, 2], [0, -2]]
  end

  def can_castle?(move)
    position_after_move = add(@position, move)
    position_of_castling_piece = add(move[1].positive? ? [0, 1] : [0, -2], position_after_move)
    piece_castling_with = @board.piece_at(position_of_castling_piece)
    return false if piece_castling_with.nil?

    squares_along_move = @board.positions_in_row(@position, position_after_move)
    !@moved && castling_pattern.include?(move) &&
      !piece_castling_with.moved && piece_castling_with.is_a?(Rook) &&
      case @color
      when :white
        (@board.squares_attacked_by_black & squares_along_move).empty?
      when :black
        (@board.squares_attacked_by_white & squares_along_move).empty?
      end
  end
end
