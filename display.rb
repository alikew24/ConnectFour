require 'colorize'
require_relative 'cursor'
require_relative 'board'
require 'byebug'

class Display
  attr_reader :board, :cursor, :notifications

  def initialize(board)
      @board = board
      @cursor= Cursor.new([0,0], board)
      @notifications = {}
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
    if pos == cursor.cursor_pos
      background = :light_black
    elsif (pos[0] + pos[1]).odd?
      background = :light_yellow
    else
      background = :light_cyan
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

board = Board.new
display = Display.new(board)
display.render
