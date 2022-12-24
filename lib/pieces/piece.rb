# frozen_string_literal: true

require './lib/vectors'
require './lib/helper'
class Piece
  include Vectors
  include Helper
  attr_reader :color, :position

  def initialize(color, position, board)
    @position = position
    @color = color
    @board = board
    @moved = false
  end

  def move(move)
    @board.remove_piece(@position)
    @position = add(move, @position)
    puts "position: #{@position}"
    @board.set_piece_at(@position, self)
    @moved = true
  end

  def valid_move?(move); end

  def valid_moves
    movement_pattern.select { |move| valid_move?(move) }
  end

  def movement_pattern; end

  def piece_blocking_move?; end

  def attacked_squares; end

  def move_is_zero?(move)
    move[0].zero? && move[1].zero?
  end

  def first_piece_in_array(array)
    array.find { |piece| !piece.nil? }
  end

  # visible means direct line of sight
  def visible_pieces_in_column
    all_pieces = @board.all_pieces_in_column(@position[1])
    piece_below = previous_piece_in_array(all_pieces, @position)
    piece_above = next_piece_in_array(all_pieces, @position)
    [piece_below, piece_above].compact.map(&:position)
  end

  def visible_pieces_in_row
    all_pieces = @board.all_pieces_in_row(@position[0])
    piece_left = previous_piece_in_array(all_pieces, @position)
    piece_right = next_piece_in_array(all_pieces, @position)
    [piece_left, piece_right].compact.map(&:position)
  end

  def visible_pieces_in_ascending_diagonal
    all_pieces = @board.all_pieces_in_ascending_diagonal(@position)
    piece_before = previous_piece_in_array(all_pieces, @position)
    piece_after = next_piece_in_array(all_pieces, @position)
    [piece_before, piece_after].compact.map(&:position)
  end

  def visible_pieces_in_descending_diagonal
    all_pieces = @board.all_pieces_in_descending_diagonal(@position)
    piece_before = previous_piece_in_array(all_pieces, @position)
    piece_after = next_piece_in_array(all_pieces, @position)
    [piece_before, piece_after].compact.map(&:position)
  end

  def next_piece_in_array(pieces, reference_point)
    next_piece = nil
    pieces.compact.each do |piece|
      position = piece.position
      next if position[0] <= reference_point[0] && position[1] <= reference_point[1]

      next_piece = @board.piece_at(position)
      break if next_piece.is_a?(Piece)
    end
    next_piece
  end

  def previous_piece_in_array(pieces, reference_point)
    previous_piece = nil
    pieces.compact.each do |piece|
      position = piece.position
      break if position[0] >= reference_point[0] && position[1] >= reference_point[1]

      previous_piece = @board.piece_at(position)
    end
    previous_piece
  end
end
