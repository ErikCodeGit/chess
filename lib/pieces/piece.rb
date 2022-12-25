# frozen_string_literal: true

require './lib/vectors'
require './lib/helper'
class Piece
  include Vectors
  include Helper
  attr_reader :color, :position
  attr_accessor :board

  def initialize(color, position, board)
    @position = position
    @color = color
    @board = board
    @moved = false
  end

  def move(move)
    @board.remove_piece(@position)
    @position = add(move, @position)
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

  def expose_king_to_mate?(move)
    board_copy = @board.deep_copy
    board_copy.move_piece(@position, add(@position, move), nil, @color)
    case @color
    when :white
      board_copy.white_king_in_check?
    when :black
      board_copy.black_king_in_check?
    end
  end

  def king_in_check?
    case @color
    when :white
      @board.white_king_in_check?
    when :black
      @board.black_king_in_check?
    end
  end

  # visible means direct line of sight
  def visible_squares_in_column
    all_positions = @board.all_positions_in_column(@position[1])
    position_below = previous_piece_position_in_array(all_positions, @position)
    position_above = next_piece_position_in_array(all_positions, @position)
    [position_below, position_above]
  end

  def visible_squares_in_row
    all_positions = @board.all_positions_in_row(@position[0])
    position_left = previous_piece_position_in_array(all_positions, @position)
    position_right = next_piece_position_in_array(all_positions, @position)
    [position_left, position_right]
  end

  def visible_squares_in_ascending_diagonal
    all_positions = @board.all_positions_in_ascending_diagonal(@position)
    position_before = previous_piece_position_in_array(all_positions, @position)
    position_after = next_piece_position_in_array(all_positions, @position)
    [position_before, position_after]
  end

  def visible_squares_in_descending_diagonal
    all_positions = @board.all_positions_in_descending_diagonal(@position)
    position_before = previous_piece_position_in_array(all_positions, @position)
    position_after = next_piece_position_in_array(all_positions, @position)
    [position_before, position_after]
  end

  def all_visible_squares_in_column
    result = []
    visible_squares_in_column.each do |position|
      result |= @board.positions_in_column(@position, position)
    end
    result.uniq
  end

  def all_visible_squares_in_row
    result = []
    visible_squares_in_row.each do |position|
      result |= @board.positions_in_row(@position, position)
    end
    result.uniq
  end

  def all_visible_squares_in_ascending_diagonal
    result = []
    visible_squares_in_ascending_diagonal.each do |position|
      result |= @board.positions_in_ascending_diagonal(@position, position)
    end
    result.uniq
  end

  def all_visible_squares_in_descending_diagonal
    result = []
    visible_squares_in_descending_diagonal.each do |position|
      result |= @board.positions_in_descending_diagonal(@position, position)
    end
    result.uniq
  end

  def next_piece_position_in_array(positions, reference_point)
    next_piece = nil
    positions.each do |position|
      next if position[0] <= reference_point[0] && position[1] <= reference_point[1]

      next_piece = @board.piece_at(position)
      break if next_piece.is_a?(Piece)
    end
    next_piece.nil? ? positions.last : next_piece.position
  end

  def previous_piece_position_in_array(positions, reference_point)
    previous_piece = nil
    positions.each do |position|
      break if position[0] >= reference_point[0] && position[1] >= reference_point[1]

      previous_piece = @board.piece_at(position)
    end
    previous_piece.nil? ? positions.first : previous_piece.position
  end

  def move_out_of_bounds?(move)
    position_after_move = add(@position, move)
    !position_after_move[0].between?(0, 7) || !position_after_move[1].between?(0, 7)
  end
end
