require 'io/console'

require_relative 'board'
require_relative 'human_player'
require_relative 'display'
require 'byebug'

class Game
  attr_reader :board, :display, :current_player, :players
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @players = {
      red: HumanPlayer.new("red", @display),
      blue: HumanPlayer.new("blue", @display)
    }
    @current_player = :red
  end

  def play
    until board.over?
      begin
        chosen_pos = players[current_player].get_move(board)
        board.place_chip(chosen_pos, players[current_player].chip)
        swap_turn!

      rescue StandardError => e
        @display.notifications[:errors] = e.message
        retry
      end
    end
    display.render
    puts "#{current_player.capitalize} loses."

    nil
  end

  private
  def swap_turn!
    @current_player = (current_player == :red) ? :blue : :red
  end


end
game = Game.new
game.play
