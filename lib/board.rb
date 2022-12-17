# frozen_string_literal: true

class Board
  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
    set_up_board
  end

  def set_up_board; end

  def move_piece(start_position, end_position)
    piece = @grid[start_position]
    return false unless piece.valid_move?(end_position)

    @grid[end_position] = @grid[start_position]
  end

  def check_winner
    @player1 if @player1.in_checkmate?
    @player2 if @player2.in_checkmate?
  end
end
