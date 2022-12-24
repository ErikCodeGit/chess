# frozen_string_literal: true

require './lib/pieces/king'
class Player
  attr_accessor :name, :color, :id, :king

  def initialize(color = :white, id = 1, name = 'Guest')
    @color = color
    @id =  id
    @name = name
    @king = nil
  end

  def in_checkmate?
    king.valid_moves.empty? && @king.in_check?
  end
end
