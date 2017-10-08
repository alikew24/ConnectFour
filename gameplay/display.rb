require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_reader :board, :cursor, :notifications
  attr_accessor :current_column

  def initialize(board)
      @board = board
      @cursor= Cursor.new([0,0], board)
      @notifications = {}
      @current_column = nil
  end

  # for notifcations
  def reset!
    @notifications.delete(:error)
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    j = 0
    current_row = row.inject("") do |line, piece|
      pos = [i, j]
      j += 1
      line + build_square(pos, piece)
    end
    return current_row
  end

  def build_square(pos, piece)
    self.current_column = cursor.cursor_pos[1]
    dark_background = false
    if pos == cursor.cursor_pos
      dark_background = true
    elsif pos[1] == self.current_column
      dark_background = true
    end
    if (pos[0] + pos[1]).odd?
      background = dark_background ? :yellow : :light_yellow
    else
      background = dark_background ? :cyan : :light_cyan
    end
    stringified_piece = piece ? "  #{piece}  " : "     "
    square = stringified_piece.colorize(background: background)
    return square
  end

  def render
    system("clear")
    puts "Use the arrow keys to move. Press space or enter to confirm move."
    @notifications.each do |key, val|
      puts "#{val}"
    end
    puts build_grid
  end
end
