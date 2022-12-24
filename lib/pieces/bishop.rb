# frozen_string_literal: true

require './lib/pieces/piece'
class Bishop < Piece
  def valid_move?(move)
    (movement_pattern.include?(move) &&
      (!piece_blocking_move?(move) ||
      can_take?(move)))
  end

  # [1, -1]
  # [ -1, 1]
  # [1, 1]
  # [-1, -1]
  def piece_blocking_move?(move)
    # if same sign
    if move[0] == move[1]
      pieces_along_move = @board.pieces_in_ascending_diagonal(@position, add(@position, move))
      # if different signs
    elsif move[0] == -move[1]
      pieces_along_move = @board.pieces_in_descending_diagonal(@position, add(@position, move))
    end
    return false if pieces_along_move.nil?

    pieces_along_move.any? { |piece| !piece.nil? }
  end

  def attacked_squares
    (valid_moves.map do |move|
      add(@position, move)
    end + visible_pieces_in_ascending_diagonal + visible_pieces_in_descending_diagonal).uniq
  end

  def movement_pattern
    (@board.generate_ascending_diagonal_moves(@position) + @board.generate_descending_diagonal_moves(@position)).delete_if do |move|
      move_is_zero?(move)
    end
  end

  def can_take?(move)
    new_position = add(@position, move)
    piece_at_new_position = @board.piece_at(new_position)
    if move[0] == move[1]
      visible_pieces = visible_pieces_in_ascending_diagonal
    elsif move[0] == -move[1]
      visible_pieces = visible_pieces_in_descending_diagonal
    end
    return false if piece_at_new_position.nil? || visible_pieces.nil? || visible_pieces.empty?

    visible_pieces.include?(new_position) && piece_at_new_position.color == opposite_color(@color)
  end
end
