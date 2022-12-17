# frozen_string_literal: true

require './lib/pieces/king'
class Player
  attr_accessor :name, :color, :id, :king

  def initialize(color = :white, id = 1, name = 'Guest')
    @color = color
    @id =  id
    @name = name
  end

  def in_checkmate?
    @king.in_check? && @king.valid_moves.empty?
  end
end
