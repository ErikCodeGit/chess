# frozen_string_literal: true

require './lib/board'
require './lib/display'
require './lib/player'
include Display
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }

@board = Board.new
@board.set_up_board
@board.set_piece_at([6, 4], Queen.new(:black, [6, 4], @board))
display_board

p @board.white_king_in_check?
p @board.piece_at([6, 4]).all_visible_squares.map { |coordinates| Board.unparse_coordinates(coordinates) }
