# frozen_string_literal: true

Dir['./lib/pieces/*.rb'].sort.each { |file| require file }
require './lib/vectors'
class Board
  attr_accessor :grid, :white_king, :black_king

  include Vectors

  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
    @white_king = @black_king = nil
  end

  def deep_copy
    result = Board.new
    @grid.each do |row|
      row.each do |piece|
        next if piece.nil?

        result.set_piece_at(piece.position, piece.clone)
        result.piece_at(piece.position).board = result unless result.piece_at(piece.position).nil?
      end
    end
    result.white_king = @white_king.clone
    result.black_king = @black_king.clone

    result
  end

  def set_up_board
    @grid[1].map!.with_index { |_piece, index| Pawn.new(:white, [1, index], self) }
    @grid[6].map!.with_index { |_piece, index| Pawn.new(:black, [6, index], self) }
    @grid[0][0] = Rook.new(:white, [0, 0], self)
    @grid[0][1] = Knight.new(:white, [0, 1], self)
    @grid[0][2] = Bishop.new(:white, [0, 2], self)
    @grid[0][3] = Queen.new(:white, [0, 3], self)
    @white_king = @grid[0][4] = King.new(:white, [0, 4], self)
    @grid[0][5] = Bishop.new(:white, [0, 5], self)
    @grid[0][6] = Knight.new(:white, [0, 6], self)
    @grid[0][7] = Rook.new(:white, [0, 7], self)

    @grid[7][0] = Rook.new(:black, [7, 0], self)
    @grid[7][1] = Knight.new(:black, [7, 1], self)
    @grid[7][2] = Bishop.new(:black, [7, 2], self)
    @grid[7][3] = Queen.new(:black, [7, 3], self)
    @black_king = @grid[7][4] = King.new(:black, [7, 4], self)
    @grid[7][5] = Bishop.new(:black, [7, 5], self)
    @grid[7][6] = Knight.new(:black, [7, 6], self)
    @grid[7][7] = Rook.new(:black, [7, 7], self)
  end

  def move_piece(start_position, end_position, current_player = nil, current_player_color = nil)
    return if (piece = piece_at(start_position)).nil?

    if current_player
      player_color = current_player.color
    elsif current_player_color
      player_color = current_player_color
    end
    return unless piece.color == player_color

    move = subtract(end_position, start_position)
    if piece.is_a?(King) && piece.castling_pattern.include?(move)
      castle(start_position, move)
    else
      piece.move(move)
    end
  end

  def castle(start_position, move)
    king = piece_at(start_position)
    king_position_after_move = add(start_position, move)
    position_of_castling_piece = add(move[1].positive? ? [0, 1] : [0, -2], king_position_after_move)
    piece_castling_with = piece_at(position_of_castling_piece)
    return if piece_castling_with.nil?

    position_of_castling_piece_after_move = add(king_position_after_move, move[1].positive? ? [0, -1] : [0, 1])
    king.move(subtract(king_position_after_move, start_position))
    piece_castling_with.move(subtract(position_of_castling_piece_after_move, position_of_castling_piece))
  end

  def remove_piece(position)
    @grid[position[0]][position[1]] = nil
    if position == @white_king.position
      @white_king = nil
    elsif position == @black_king.position
      @black_king = nil
    end
  end

  def set_piece_at(position, piece)
    @grid[position[0]][position[1]] = piece
    if piece.is_a?(King) && piece.color == :white
      @white_king = piece
    elsif piece.is_a?(King) && piece.color == :black
      @black_king = piece
    end
  end

  def self.parse_coordinates(coordinates)
    [coordinates[1].to_i - 1, coordinates[0].downcase.codepoints[0] - 97]
  end

  def self.unparse_coordinates(coordinates)
    "#{(coordinates[1] + 97).chr}#{coordinates[0] + 1}"
  end

  def piece_at(position)
    @grid[position[0]][position[1]]
  end

  def promote(position, promotion)
    pawn_before_promotion = piece_at(position)
    new_piece = nil
    case promotion
    when 'q'
      new_piece = Queen.new(pawn_before_promotion.color, position, self)
    when 'r'
      new_piece = Rook.new(pawn_before_promotion.color, position, self)
    when 'k'
      new_piece = Knight.new(pawn_before_promotion.color, position, self)
    when 'b'
      new_piece = Bishop.new(pawn_before_promotion.color, position, self)
    end
    set_piece_at(position, new_piece)
  end

  def promotion?(position)
    piece = piece_at((position))
    piece.is_a?(Pawn) && piece.position[0] == (piece.color == :white ? 7 : 0)
  end

  def pieces_at(positions)
    result = []
    positions.each do |position|
      result << piece_at(position)
    end
    result
  end

  def positions_in_column(start_position, end_position)
    return unless start_position[1] == end_position[1]

    increment = start_position[0] <= end_position[0] ? [1, 0] : [-1, 0]
    result = []
    current_position = start_position.dup
    until current_position == end_position
      current_position = add(current_position, increment)
      result << current_position
    end
    result
  end

  def positions_in_row(start_position, end_position)
    return unless start_position[0] == end_position[0]

    increment = start_position[1] <= end_position[1] ? [0, 1] : [0, -1]
    result = []
    current_position = start_position.dup
    until current_position == end_position
      current_position = add(current_position, increment)
      result << current_position
    end
    result
  end

  def positions_in_ascending_diagonal(start_position, end_position)
    # differnce of x and y of two points along a diagonal are always equal
    difference = subtract(end_position, start_position)
    return unless difference[0] == difference[1]

    result = []
    increment = end_position[0] > start_position[0] ? [1, 1] : [-1, -1]
    current_position = start_position.dup
    until current_position == end_position
      current_position = add(current_position, increment)
      result << current_position
    end
    result
  end

  def positions_in_descending_diagonal(start_position, end_position)
    # differnce of x and -y of two points along a diagonal are always equal
    difference = subtract(end_position, start_position)
    return unless difference[0] == -difference[1]

    result = []
    increment = end_position[0] > start_position[0] ? [1, -1] : [-1, 1]
    current_position = start_position.dup
    until current_position == end_position
      current_position = add(current_position, increment)
      result << current_position
    end
    result
  end

  def pieces_in_column(start_position, end_position = start_position)
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

  def pieces_in_row(start_position, end_position = start_position)
    return unless start_position[0] == end_position[0]

    increment = start_position[1] <= end_position[1] ? 1 : -1
    result = []
    current_position = start_position.dup
    until current_position == end_position
      current_position[1] += increment
      result << piece_at(current_position)
    end
    result
  end

  def pieces_in_ascending_diagonal(start_position, end_position = start_position)
    # differnce of x and y of two points along a diagonal are always equal
    difference = subtract(end_position, start_position)
    return unless difference[0] == difference[1]

    result = []
    increment = end_position[0] > start_position[0] ? [1, 1] : [-1, -1]
    current_position = start_position.dup
    until current_position == end_position
      current_position = add(current_position, increment)
      result << piece_at(current_position)
    end
    result
  end

  def pieces_in_descending_diagonal(start_position, end_position = start_position)
    # differnce of x and -y of two points along a diagonal are always equal
    difference = subtract(end_position, start_position)
    return unless difference[0] == -difference[1]

    result = []
    increment = end_position[0] > start_position[0] ? [1, -1] : [-1, 1]
    current_position = start_position.dup
    until current_position == end_position
      current_position = add(current_position, increment)
      result << piece_at(current_position)
    end
    result
  end

  def all_pieces_in_column(column_index)
    return unless column_index.between?(0, 7)

    result = []
    8.times do |index|
      result << piece_at([index, column_index])
    end
    result
  end

  def all_pieces_in_row(row_index)
    return unless row_index.between?(0, 7)

    result = []
    8.times do |index|
      result << piece_at([row_index, index])
    end
    result
  end

  def all_pieces_in_ascending_diagonal(start_position)
    result = []
    current_position = subtract_until_at_edge(start_position.dup, [1, 1])
    while current_position[0].between?(0, 7) && current_position[1].between?(0, 7)
      result << piece_at(current_position)
      current_position = add(current_position, [1, 1])
    end
    result
  end

  def all_pieces_in_descending_diagonal(start_position)
    result = []
    current_position = subtract_until_at_edge(start_position.dup, [-1, 1])
    while current_position[0].between?(0, 7) && current_position[1].between?(0, 7)
      result << piece_at(current_position)
      current_position = add(current_position, [-1, 1])
    end
    result
  end

  def all_positions_in_column(column_index)
    return unless column_index.between?(0, 7)

    result = []
    8.times do |index|
      result << [index, column_index]
    end
    result
  end

  def all_positions_in_row(row_index)
    return unless row_index.between?(0, 7)

    result = []
    8.times do |index|
      result << [row_index, index]
    end
    result
  end

  def all_positions_in_ascending_diagonal(start_position)
    result = []
    current_position = subtract_until_at_edge(start_position.dup, [1, 1])
    while current_position[0].between?(0, 7) && current_position[1].between?(0, 7)
      result << current_position
      current_position = add(current_position, [1, 1])
    end
    result
  end

  def all_positions_in_descending_diagonal(start_position)
    result = []
    current_position = subtract_until_at_edge(start_position.dup, [-1, 1])
    while current_position[0].between?(0, 7) && current_position[1].between?(0, 7)
      result << current_position
      current_position = add(current_position, [-1, 1])
    end
    result
  end

  def generate_column_moves(start_position)
    result = []
    current_position = [0, start_position[1]]
    while current_position[0] < 8
      result << subtract(current_position, start_position)
      current_position[0] += 1
    end
    result
  end

  def generate_row_moves(start_position)
    result = []
    current_position = [start_position[0], 0]
    while current_position[1] < 8
      result << subtract(current_position, start_position)
      current_position[1] += 1
    end
    result
  end

  def generate_ascending_diagonal_moves(start_position)
    result = []
    current_position = subtract_until_at_edge(start_position.dup, [1, 1])
    while current_position[0].between?(0, 7) && current_position[1].between?(0, 7)
      result << subtract(current_position, start_position)
      current_position = add(current_position, [1, 1])
    end
    result
  end

  def generate_descending_diagonal_moves(start_position)
    result = []
    current_position = subtract_until_at_edge(start_position.dup, [-1, 1])
    while current_position[0].between?(0, 7) && current_position[1].between?(0, 7)
      result << subtract(current_position, start_position)
      current_position = add(current_position, [-1, 1])
    end
    result
  end

  def squares_attacked_by_white
    result = []
    all_white_pieces.each do |piece|
      next if piece.nil? || piece.attacked_squares.nil?

      result |= piece.attacked_squares
    end
    result
  end

  def squares_attacked_by_black
    result = []
    all_black_pieces.each do |piece|
      next if piece.nil? || (attacked_squares_of_piece = piece.attacked_squares).nil?

      result |= attacked_squares_of_piece
    end
    result
  end

  def all_white_pieces
    result = []
    @grid.each do |row|
      row.each do |piece|
        next if piece.nil?

        result << piece if piece.color == :white
      end
    end
    result
  end

  def all_black_pieces
    result = []
    @grid.each do |row|
      row.each do |piece|
        next if piece.nil?

        result << piece if piece.color == :black
      end
    end
    result
  end

  def white_king_in_check?
    squares_attacked_by_black.include?(@white_king.position)
  end

  def black_king_in_check?
    squares_attacked_by_white.include?(@black_king.position)
  end

  def white_has_valid_moves?
    all_white_pieces.any? do |piece|
      !piece.valid_moves.empty?
    end
  end

  def black_has_valid_moves?
    all_black_pieces.any? do |piece|
      !piece.valid_moves.empty?
    end
  end

  def player_in_checkmate?(player)
    case player.color
    when :white
      white_king_in_check? && !white_has_valid_moves?
    when :black
      black_king_in_check? && !black_has_valid_moves?
    end
  end

  def stalemate?(current_player)
    case current_player.color
    when :white
      !white_king_in_check? && !white_has_valid_moves?
    when :black
      !black_king_in_check? && !black_has_valid_moves?
    end
  end

  def movable_pieces_positions(color)
    case color
    when :white
      all_white_pieces.reject { |piece| piece.valid_moves.empty? }.map(&:position)
    when :black
      all_black_pieces.reject { |piece| piece.valid_moves.empty? }.map(&:position)
    end
  end
end
