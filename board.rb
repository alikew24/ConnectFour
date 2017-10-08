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
    raise 'Invalid Position' unless valid_pos?(pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    raise 'Invalid Position' unless valid_pos?(pos)
    row, col = pos
    @grid[row][col] = piece
  end

  def place_chip(pos, chip)
    raise 'There is already a chip in that spot' unless empty?(pos)
    row, col = pos
    pos2 = [row + 1, col]
    raise 'Invalid Move' if valid_pos?(pos2) && empty?(pos2)
    self[pos] = chip
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

  def over?
    self.check_for_winner(4)
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
