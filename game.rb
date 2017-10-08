require 'io/console'

require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'
require_relative 'display'
require 'byebug'

class Game
  attr_reader :board, :display, :current_player, :players
  def initialize(player_1_name, player_2_name)
    @board = Board.new
    @display = Display.new(@board)
    @players = {
      red: HumanPlayer.new(player_1_name, "red", @display),
      blue: ComputerPlayer.new(player_2_name, "blue", @display)
    }
    @current_player = :red
  end

  def show_instructions
    puts <<-HEREDOC
    Welcome to Connect Four! The goal is to place 4 chips in a row.
    The first person to get four-in-a-row wins! To play, simply use
    the arrow keys to move to a different column. Press the enter key
    when you have selected the column that you want to place your chip.
    You are red and the Computer is blue.

    Press any key to continue
    HEREDOC

    STDIN.getch
  end

  def run
    system("clear")
    self.show_instructions
    system("clear")
    until board.over?
      begin
        self.play_turn
      rescue StandardError => e
        @display.notifications[:errors] = e.message
        retry
      end
    end
    display.render
    if board.full?
      puts "The game ends in a tie."
    else
      winner = current_player == :red ? :blue : :red
      winner_name = self.players[winner].name
      puts "#{winner_name} wins."
    end
  end

  def play_turn
    display.render
    if current_player == :blue
      puts "Computer is thinking..."
      sleep(2)
    end
    chosen_column = players[current_player].get_move(board)
    board.place_chip(chosen_column, players[current_player].chip)
    swap_turn!
    system("clear")
  end

  private
  def swap_turn!
    @current_player = (current_player == :red) ? :blue : :red
  end


end

if __FILE__ == $PROGRAM_NAME
  system("clear")
  print "What is your name?\n"
  name = gets.chomp.strip
  Game.new(name, "Computer").run
end
