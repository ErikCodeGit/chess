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
@board.remove_piece([0, 5])
@board.remove_piece([0, 6])
@board.set_piece_at([1, 7], Knight.new(:black, [1, 7], @board))
test_display_board

p @board.white_king.valid_moves
