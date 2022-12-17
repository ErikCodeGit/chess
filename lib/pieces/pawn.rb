# frozen_string_literal: true

require './lib/pieces/piece.rb'
class Pawn < Piece

  def valid_move?(move)
    !piece_blocking_move?(move)
  end

  def piece_blocking_move?(move)
    true if @board[move[0]][move[1]].nil?
    false
  end
end
