# frozen_string_literal: true

require_relative 'display'
require_relative 'constants'
require_relative 'player'
require_relative 'board'
class Game
  include Display
  include Constants

  def initialize
    @player1 = Player.new(:white, 1)
    @player2 = Player.new(:black, 2)
    @current_player = @player1
    @board = Board.new
    start_game
  end

  def start_game
    display_start_message
    create_player_names
    game_loop
    display_winner_message
  end

  def game_loop
    loop do
      prompt_player_move_start
      prompt_player_move_end
      break if winner

      flip_current_player
    end
  end

  def winner
    @board.check_winner
  end

  def flip_current_player
    @current_player = if @current_player == @player1
                        @player2
                      else
                        @player1
                      end
  end

  def create_player_names
    @player1.name = prompt_player_name(@player1)
    @player2.name = prompt_player_name(@player2)
  end
end
