require_relative 'player'
require_relative 'board'
require_relative 'display'
class HumanPlayer < Player
  def get_move(board)
    chosen_pos = nil
    until chosen_pos
      display.render
      puts "where would you like to move"
      chosen_pos = display.cursor.get_input
    end
    display.reset!
    return chosen_pos
  end
end
