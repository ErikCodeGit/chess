# frozen_string_literal: true

class Player
  attr_accessor :name, :color, :id, :king

  def initialize(color = :white, id = 1, name = 'Guest')
    @color = color
    @id =  id
    @name = name
    @king = King.new(color)
  end

  def in_checkmate?
    @king.in_check? && @king.valid_moves.empty?
  end
end
