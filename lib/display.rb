# frozen_string_literal: true

require_relative 'constants'
require_relative 'player'
module Display
  include Constants
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
    print "Player #{@current_player.id}, enter the position of the piece you want to move: "
    position = ''
    loop do
      position = gets.chomp
      break if valid_coordinates(position)

      print 'Please enter a valid position: '
    end
    display_horizontal_row
    position
  end

  def prompt_player_move_end
    print "Player #{@current_player.id}, enter the position you want to move the piece to: "
    position = ''
    loop do
      position = gets.chomp
      break if valid_coordinates(position)

      print 'Please enter a valid position: '
    end
    display_horizontal_row
    position
  end

  def display_board(board); end

  def valid_coordinates(coordinates)
    coordinates.length == 2 && coordinates[0].match(/[a-h]/i) && coordinates[1].match(/[1-8]/)
  end
end
