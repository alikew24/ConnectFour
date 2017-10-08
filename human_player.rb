require_relative 'player'
require_relative 'board'
require_relative 'display'
require 'byebug'
class HumanPlayer < Player
  def get_move(board)
    chosen_pos = nil
    until chosen_pos
      display.render
      puts "#{self.name}, where would you like to move?"
      chosen_pos = display.cursor.get_input
    end
    display.reset!
    return chosen_pos[1]
  end
end
