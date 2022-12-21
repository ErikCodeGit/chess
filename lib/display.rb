# frozen_string_literal: true

require_relative 'constants'
require_relative 'player'
require_relative 'board'
require './lib/vectors'
Dir['./lib/pieces/*.rb'].sort.each { |file| require file }
module Display
  include Constants
  include Vectors
  def display_start_message
    display_horizontal_row
    puts "LET'S PLAY A GAME OF CHESS!"
    display_horizontal_row
  end

  def prompt_player_name(player)
    print "Player #{player.id} (#{player.color}), please enter your name: "
    name = ''
    loop do
      name = gets.chomp
      break if name.length.between?(1, 50)

      print 'Please enter a valid name(1-50 characters): '
    end
    display_horizontal_row
    name
  end

  def display_horizontal_row
    puts HORIZONTAL_ROW_CHARACTER * HORIZONTAL_ROW_WIDTH
  end

  def prompt_player_move_start
    print "#{@current_player.name}, enter the position of the piece you want to move: "
    position = ''
    loop do
      position = gets.chomp
      if valid_coordinates?(position) && !empty_tile?(Board.parse_coordinates(position)) && own_piece?(Board.parse_coordinates(position))
        break
      end

      print 'Please enter a valid position: '
    end
    display_horizontal_row
    Board.parse_coordinates(position)
  end

  def prompt_player_move_end(start_position)
    print "#{@current_player.name}, enter the position you want to move the piece to: "
    position = ''
    loop do
      position = gets.chomp
      break if valid_coordinates?(position) && valid_move?(start_position,
                                                           Board.parse_coordinates(position))

      print 'Please enter a valid position: '
    end
    display_horizontal_row
    Board.parse_coordinates(position)
  end

  def display_board
    row_number = 8
    @board.grid.reverse.each do |row|
      print "#{row_number} "
      row_number -= 1
      row.each do |piece|
        print "#{piece_to_string(piece)} "
      end
      puts
    end
    puts '  a b c d e f g h'
    display_horizontal_row
  end

  def display_flipped_board
    row_number = 1
    @board.grid.each do |row|
      print "#{row_number} "
      row_number += 1
      row.each do |piece|
        print "#{piece_to_string(piece)} "
      end
      puts
    end
    puts '  a b c d e f g h'
    display_horizontal_row
  end

  def piece_to_string(piece)
    return EMPTY_SYMBOL if piece.nil?

    color = piece.color
    if piece.instance_of?(Pawn)
      PAWN_SYMBOL[color]
    elsif piece.instance_of?(Knight)
      KNIGHT_SYMBOL[color]
    elsif piece.instance_of?(Bishop)
      BISHOP_SYMBOL[color]
    elsif piece.instance_of?(Rook)
      ROOK_SYMBOL[color]
    elsif piece.instance_of?(Queen)
      QUEEN_SYMBOL[color]
    elsif piece.instance_of?(King)
      KING_SYMBOL[color]
    else
      'X'
    end
  end

  def valid_coordinates?(coordinates)
    (coordinates.length == 2) &&
      coordinates[0].match(/[a-h]/i) &&
      coordinates[1].match(/[1-8]/)
  end

  def empty_tile?(position)
    @board.piece_at(position).nil?
  end

  def own_piece?(position)
    @board.piece_at(position).color == @current_player.color
  end

  def valid_move?(start_position, end_position)
    @board.piece_at(start_position).valid_move?(subtract(end_position, start_position))
  end
end
