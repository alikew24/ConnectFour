require 'colorize'
require 'byebug'

class Board
  attr_accessor :grid
  def self.blank_grid
    Array.new(6){Array.new(7)}
  end

  def initialize(grid = Board.blank_grid)
    @grid = grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def get_first_empty_pos_in_column(column)
    row = self.grid.length - 1
    pos = [row, column]
    until empty?(pos) || pos[0] == 0
      row -= 1
      pos = [row, column]
    end
    return pos
  end

  def place_chip(column, chip)
    raise 'That column is full' unless empty?([0, column])
    pos = self.get_first_empty_pos_in_column(column)
    self[pos] = chip
  end

  def column_full?(column)
    empty?([0, column]) ? false : true
  end

  def check_spots(pos, increment, num_of_spots_to_check)
    count = num_of_spots_to_check - 1
    row, col = pos
    dx, dy = increment
    if valid_pos? ([row + (count * dx), col + (count * dy)])
      spots = [[row, col]]
      count.times do
        row += dx
        col += dy
        spots << [row, col]
      end
      if spots.all? { |spot| self[spot] == self[spots[0]] && !self[spot].nil?}
        return self[spots[0]]
      end
    end
    return nil
  end

  def check_for_winner(num_to_check)
    winner = nil
    row_incr = [1, 0]
    col_incr = [0, 1]
    right_diag_incr = [1, 1]
    left_diag_incr = [1, -1]
    all_incr = [row_incr, col_incr, right_diag_incr, left_diag_incr]
    self.grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        pos = [i, j]
        all_incr.each do |incr|
          result = self.check_spots(pos, incr, 4)
          unless result.nil?
            winner = result
            break
          end
        end
      end
      break if winner
    end
    return winner
  end

  def full?
    (0...self.grid.length).each do |col|
      return false unless self.column_full?(col)
    end
    return true
  end

  def over?
    self.check_for_winner(4) or self.full?
  end


  def valid_pos?(pos)
    row, col = pos
    row.between?(0, 5) && col.between?(0, 6)
  end

  def empty?(pos)
    self[pos].nil?
  end

  def add_piece?(piece, pos)
    raise "position not empty #{pos} #{piece}" unless empty?(pos)
    self[pos] = piece
  end




end
