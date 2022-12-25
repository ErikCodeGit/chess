# frozen_string_literal: true

require './lib/board'
require './lib/display'
require './lib/player'
include Display
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }

@board = Board.new
@board.set_piece_at([7, 7], Queen.new(:white, [7, 7], @board))
@board.set_piece_at([7, 4], King.new(:black, [7, 4], @board))
@board.set_piece_at([6, 3], Pawn.new(:black, [6, 3], @board))
@board.set_piece_at([6, 4], Pawn.new(:black, [6, 4], @board))
@board.set_piece_at([6, 5], Pawn.new(:black, [6, 5], @board))
@board.black_king = @board.piece_at([7, 4])
display_board

p @board.black_king_in_check?
