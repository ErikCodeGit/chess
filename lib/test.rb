# frozen_string_literal: true

require './lib/board'
require './lib/display'
require './lib/player'
include Display
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }

@board = Board.new
@board.set_piece_at([0, 0], King.new(:white, [0, 0], @board))
@board.set_piece_at([1, 2], King.new(:black, [1, 2], @board))
@board.set_piece_at([1, 1], Rook.new(:black, [1, 1], @board))
@board.white_king = @board.piece_at([0, 0])
@board.black_king = @board.piece_at([1, 2])
display_board
pablo = Player.new(:white, 1, 'pablo')
gus = Player.new(:black, 2, 'gus')
pablo.king = @board.white_king
gus.king = @board.black_king
p @board.stalemate?(pablo)
p @board.white_king.valid_moves