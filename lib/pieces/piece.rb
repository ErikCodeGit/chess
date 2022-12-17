# frozen_string_literal: true
require './lib/vectors'
class Piece
  include Vectors
  attr_reader :color, :position

  def initialize(color, position, board)
    @position = position
    @color = color
    @board = board
  end

  def move(move)
    @position = add(move, @position) if valid_move?(move)
  end

  def valid_move?(move)
    !((@board.piece_at(add(move, @position)).color == @color) || piece_blocking_move?(move))
  end

  def valid_moves; end

  def movement_pattern; end

  def piece_blocking_move?; end
end
