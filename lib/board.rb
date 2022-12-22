# frozen_string_literal: true

Dir['./lib/pieces/*.rb'].sort.each { |file| require file }
require './lib/vectors'
class Board
  attr_reader :grid

  include Vectors

  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
    set_up_board
  end

  def set_up_board
    @grid[1].map!.with_index { |_piece, index| Pawn.new(:white, [1, index], self) }
    @grid[6].map!.with_index { |_piece, index| Pawn.new(:black, [6, index], self) }
    @grid[0][0] = Rook.new(:white, [0, 0], self)
    @grid[0][1] = Knight.new(:white, [0, 1], self)
    @grid[0][2] = Bishop.new(:white, [0, 2], self)
    @grid[0][3] = Queen.new(:white, [0, 3], self)
    @grid[0][4] = King.new(:white, [0, 4], self)
    @grid[0][5] = Bishop.new(:white, [0, 5], self)
    @grid[0][6] = Knight.new(:white, [0, 6], self)
    @grid[0][7] = Rook.new(:white, [0, 7], self)

    @grid[7][0] = Rook.new(:black, [7, 0], self)
    @grid[7][1] = Knight.new(:black, [7, 1], self)
    @grid[7][2] = Bishop.new(:black, [7, 2], self)
    @grid[7][3] = Queen.new(:black, [7, 3], self)
    @grid[7][4] = King.new(:black, [7, 4], self)
    @grid[7][5] = Bishop.new(:black, [7, 5], self)
    @grid[7][6] = Knight.new(:black, [7, 6], self)
    @grid[7][7] = Rook.new(:black, [7, 7], self)
  end

  def move_piece(start_position, end_position, current_player)
    piece = @grid[start_position[0]][start_position[1]]
    return unless piece.color == current_player.color

    puts "position before move: #{piece.position}"
    print 'move: '
    piece.move(p(subtract(end_position, start_position)))
  end

  def remove_piece(position)
    @grid[position[0]][position[1]] = nil
  end

  def set_piece_at(position, piece)
    @grid[position[0]][position[1]] = piece
  end

  def self.parse_coordinates(coordinates)
    [coordinates[1].to_i - 1, coordinates[0].downcase.codepoints[0] - 97]
  end

  def piece_at(position)
    @grid[position[0]][position[1]]
  end

  def pieces_at(positions)
    result = []
    positions.each do |position|
      result << piece_at(position)
    end
    result
  end

  def pieces_in_column(start_position, end_position)
    return unless start_position[1] == end_position[1]

    increment = start_position[0] <= end_position[0] ? 1 : -1
    result = []
    current_position = start_position.dup
    until current_position == end_position
      current_position[0] += increment
      result << piece_at(current_position)
    end
    result
  end

  def pieces_in_row(start_position, end_position)
    return unless start_position[0] == end_position[0]

    increment = start_position[1] <= end_position[1] ? 1 : -1
    result = []
    current_position = start_position.dup
    current_position[1] += increment
    until current_position == end_position
      result << piece_at(current_position)
      current_position[1] += increment
    end
    result
  end

  def pieces_in_diagonal(start_position, end_position)
    # x and y of two points along a diagonal are always equal
    difference = subtract(end_position, start_position)
    return unless difference[0] == difference[1]

    increment = start_position[0] <= end_position[0] ? 1 : -1
    result = []
    current_position = start_position.dup
    until current_position == end_position
      result << piece_at(current_position)
      current_position[0] += increment
      current_position[1] += increment
    end
    result
  end
end
