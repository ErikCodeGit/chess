# frozen_string_literal: true

require './lib/board'
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }

board = Board.new
board.set_piece_at([2, 2], Rook.new(:white, [2, 2], board))
p board.piece_at([2, 2]).movement_pattern
