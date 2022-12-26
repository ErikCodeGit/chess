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
    @board.set_up_board
    @player1.king = @board.white_king
    @player2.king = @board.black_king
    update_movable_pieces
    start_game
  end

  def start_game
    display_start_message
    create_player_names
    game_loop
    display_board
    display_winner_message if @winner
    display_draw_message if @draw
  end

  def game_loop
    loop do
      display_board
      handle_checks
      start_position = prompt_player_move_start
      break if check_resign(start_position)
      break if check_draw_agreement(start_position)

      display_board(start_position)
      end_position = prompt_player_move_end(start_position)
      @board.move_piece(start_position, end_position, @current_player)
      handle_promotion(end_position) if @board.promotion?(end_position)
      check_winner
      check_draw
      break if @winner
      break if @draw

      flip_current_player
    end
  end

  def check_resign(start_position)
    return unless start_position.is_a?(String) && start_position == 'resign'

    @winner = next_player
  end

  def check_draw_agreement(start_position)
    return unless start_position.is_a?(String) && start_position == 'draw'

    @draw = true
  end

  def display_board_for_current_player
    if @current_player == @player1
      display_board
    else
      display_flipped_board
    end
  end

  def check_winner
    @winner = @player1 if @board.player_in_checkmate?(@player2)
    @winner = @player2 if @board.player_in_checkmate?(@player1)
  end

  def check_draw
    @draw = @board.stalemate?(@current_player)
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

  def handle_checks
    display_check if @board.white_king_in_check? || @board.black_king_in_check?
  end

  def handle_promotion(end_position)
    @board.promote(end_position, prompt_promotion)
  end

  def next_player
    case @current_player
    when @player1
      @player2
    when @player2
      @player1
    end
  end
end
