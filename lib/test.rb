# frozen_string_literal: true

require './lib/board'
require './lib/display'
require './lib/player'
include Display
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }

def test_display_board
  row_number = 8
  @board.grid.reverse.each_with_index do |row, index_y|
    print "#{row_number} "
    row_number -= 1
    row.each_with_index do |piece, index_x|
      print "#{piece_to_string(piece, [index_y, index_x])} "
    end
    puts
  end
  puts '  a b c d e f g h'
  display_horizontal_row
end

@board = Board.new
@board.set_up_board
@board.remove_piece([1, 4])
@board.remove_piece([1, 3])
@board.remove_piece([6, 3])
@board.move_piece([7, 3], [6, 3], nil, :black)
@board.move_piece([0, 4], [1, 3], nil, :white)
@board.move_piece([0, 5], [4, 1], nil, :white)
test_display_board

p @board.white_king.valid_moves
