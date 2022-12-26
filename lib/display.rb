# frozen_string_literal: true

require_relative 'constants'
require_relative 'player'
require_relative 'board'
require './lib/vectors'
require 'colorize'
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
    movable_pieces_coordinates = @movable_pieces_positions.map do |coordinates|
      Board.unparse_coordinates(coordinates)
    end
    loop do
      position = gets.chomp
      return 'resign' if resign_offer?(position) && confirm_resign_offer?
      return 'draw' if draw_offer?(position) && confirm_draw_offer?
      break if valid_start_input?(position)

      display_board(nil, true)
      print "Please enter a valid position (#{movable_pieces_coordinates.join(', ')}): "
    end
    display_horizontal_row
    Board.parse_coordinates(position)
  end

  def prompt_player_move_end(start_position)
    piece = @board.piece_at(start_position)
    valid_moves = piece.valid_moves.map do |move|
      Board.unparse_coordinates(add(move, piece.position))
    end
    print "#{@current_player.name}, enter the position you want to move the piece to: "
    end_position = ''
    loop do
      end_position = gets.chomp
      break if valid_end_input?(start_position, end_position)

      print "Please enter a valid position (#{valid_moves.join(', ')}): "
    end
    display_horizontal_row
    Board.parse_coordinates(end_position)
  end

  def resign_offer?(position)
    position.match(/resign/i)
  end

  def draw_offer?(position)
    position.match(/draw/i)
  end

  def confirm_resign_offer?
    print "#{@current_player.name}, are you sure you want to resign?: "
    confirmed = gets.chomp.match(/^y/i)
    display_horizontal_row
    confirmed
  end

  def confirm_draw_offer?
    print "#{@current_player.name}, are you sure you want to propose a draw?: "
    confirmed1 = gets.chomp.match(/^y/i)
    print "#{next_player.name}, do you accept the draw?: "
    confirmed2 = gets.chomp.match(/^y/i)
    display_horizontal_row
    confirmed1 && confirmed2
  end

  def valid_start_input?(start_position)
    return false unless valid_coordinates?(start_position)

    parsed_coordinates = Board.parse_coordinates(start_position)
    !empty_tile?(parsed_coordinates) &&
      own_piece?(parsed_coordinates) &&
      piece_can_move?(parsed_coordinates)
  end

  def valid_end_input?(start_position, end_position)
    valid_coordinates?(end_position) &&
      valid_move?(start_position, Board.parse_coordinates(end_position))
  end

  def display_board(selected_position = nil, highlight_movable_pieces = false)
    update_movable_pieces
    row_number = 8
    @board.grid.reverse.each_with_index do |row, index_y|
      print "#{row_number} "
      row_number -= 1
      row.each_with_index do |piece, index_x|
        print "#{piece_to_string(piece,
                                 [index_y,
                                  index_x])} ".colorize(piece_color([7 - index_y, index_x], selected_position,
                                                                    highlight_movable_pieces))
      end
      puts
    end
    puts '  a b c d e f g h'
    display_horizontal_row
  end

  def update_movable_pieces
    @movable_pieces_positions = @board.movable_pieces_positions(@current_player.color)
  end

  def piece_color(position, selected_position, highlight_movable_pieces)
    if selected_position == position
      :magenta
    elsif !selected_position.nil? && @board.piece_at(selected_position).valid_moves.map do |move|
            add(move, selected_position)
          end.include?(position)
      :blue
    elsif highlight_movable_pieces && selected_position.nil? && @movable_pieces_positions.include?(position)
      :green
    else
      :default
    end
  end

  def display_winner_message
    if @board.player_in_checkmate?(@player1) || @board.player_in_checkmate?(@player2)
      puts 'Checkmate!'.red
      display_horizontal_row
    end
    puts "#{@winner.name} wins!".green
    display_horizontal_row
  end

  def display_draw_message
    puts "It's a draw!".blue
    display_horizontal_row
  end

  def display_check
    person_in_check = @player1 if @player1.king.in_check?
    person_in_check = @player2 if @player2.king.in_check?
    puts "#{person_in_check.name} is in check!".yellow
    display_horizontal_row
  end

  def display_check_mate(player_in_mate)
    puts "#{player_in_mate.name} is in checkmate".red
  end

  def prompt_promotion
    puts 'What shall your pawn become?'.green
    puts '(Q)ueen, (R)ook, (K)night or (B)ishop?:'.green
    response = ''
    loop do
      response = gets.chomp
      break if response.match(/^[qrkb]/i)

      puts 'Please enter a valid piece:'
    end
    response[0].downcase
  end

  def piece_to_string(piece, _position)
    return EMPTY_SYMBOL_LIGHT if piece.nil?

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

  def move_array_to_s(moves, piece)
    (moves.map do |move|
      Board.unparse_coordinates(add(piece.position, move))
    end).join(', ')
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
    piece = @board.piece_at(start_position)
    piece.valid_move?(subtract(end_position, start_position))
  end

  def piece_can_move?(start_position)
    !@board.piece_at(start_position).valid_moves.empty?
  end
end
