# frozen_string_literal: true

require './lib/board'
require './lib/display'
require './lib/player'
include Display
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }

@board = Board.new
@board.set_up_board
@board.remove_piece([1, 1])
@board.remove_piece([1, 2])
@board.remove_piece([1, 3])
@board.remove_piece([1, 4])
@board.remove_piece([1, 5])
@board.remove_piece([1, 6])
@board.remove_piece([6, 1])
@board.remove_piece([6, 2])
@board.remove_piece([6, 3])
@board.remove_piece([6, 4])
@board.remove_piece([6, 5])
@board.remove_piece([6, 6])
@board.move_piece([7, 5], [3, 1], nil, :black)
display_board

p @board.white_king_in_check?
p @board.white_king.valid_moves
