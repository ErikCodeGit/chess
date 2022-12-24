# frozen_string_literal: true

require './lib/pieces/piece'
class Rook < Piece
  def valid_move?(move)
    (movement_pattern.include?(move) &&
      (!piece_blocking_move?(move) ||
      can_take?(move)))
  end

  def movement_pattern
    (@board.generate_column_moves(@position) + @board.generate_row_moves(@position)).delete_if do |move|
      move_is_zero?(move)
    end
  end

  def piece_blocking_move?(move)
    if move[0].zero?
      pieces_along_move = @board.pieces_in_row(@position, add(@position, move))
    elsif move[1].zero?
      pieces_along_move = @board.pieces_in_column(@position, add(@position, move))
    end
    return false if pieces_along_move.nil?

    pieces_along_move.any? { |piece| !piece.nil? }
  end

  def attacked_squares
    (valid_moves.map do |move|
      add(@position, move)
    end + visible_pieces_in_column + visible_pieces_in_row).uniq
  end

  def can_take?(move)
    new_position = add(@position, move)
    piece_at_new_position = @board.piece_at(new_position)
    if move[0].zero?
      visible_pieces = visible_pieces_in_row
    elsif move[1].zero?
      visible_pieces = visible_pieces_in_column
    end
    return false if piece_at_new_position.nil? || visible_pieces.nil? || visible_pieces.empty?

    visible_pieces.include?(piece_at_new_position) && piece_at_new_position.color == @color
  end
end
