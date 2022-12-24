# frozen_string_literal: true

require './lib/board'
require './lib/display'
include Display
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }

@board = Board.new
@board.set_piece_at([2, 2], Bishop.new(:white, [2, 2], @board))
bishop = @board.piece_at([2, 2])
display_board
puts move_array_to_s(bishop.movement_pattern, bishop)
puts move_array_to_s(bishop.valid_moves, bishop)
