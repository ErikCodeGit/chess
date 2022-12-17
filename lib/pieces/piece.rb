# frozen_string_literal: true

require_relative '../board'

class Piece
  include Board
  def initialize(color, position)
    @position = position
    @color = color
  end

  def move(move)
    @position = @position.add(move) if valid_move?(move)
  end

  def valid_move?(move)
    !((@board.piece_at(@position.add(move)).color == @color) || piece_blocking_move?(move))
  end

  def valid_moves; end

  def movement_pattern; end

  def piece_blocking_move?; end
end
