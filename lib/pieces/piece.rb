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
  end

  def valid_move?(move); end

  def valid_moves; end

  def movement_pattern; end

  def piece_blocking_move?; end
end
