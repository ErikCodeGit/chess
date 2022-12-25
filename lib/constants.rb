# frozen_string_literal: true
require 'colorize'

module Constants
  HORIZONTAL_ROW_WIDTH = 75
  HORIZONTAL_ROW_CHARACTER = '🭹'
  PAWN_SYMBOL = { white: '♟︎', black: '♙' }.freeze
  KNIGHT_SYMBOL = { white: '♞', black: '♘' }.freeze
  BISHOP_SYMBOL = { white: '♝', black: '♗' }.freeze
  ROOK_SYMBOL = { white: '♜', black: '♖' }.freeze
  QUEEN_SYMBOL = { white: '♛', black: '♕' }.freeze
  KING_SYMBOL = { white: '♚', black: '♔' }.freeze
  EMPTY_SYMBOL_LIGHT = '■'
  EMPTY_SYMBOL_DARK = '■'.green
end
