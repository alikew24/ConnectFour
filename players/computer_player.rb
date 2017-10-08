require "deep_clone"
require_relative 'player'
require './gameplay/board'
require'./gameplay/display'

class ComputerPlayer < Player

  def get_move(board)
    valid_moves = self.get_valid_moves(board)
    chip = Player.get_player_chip('blue')
    valid_moves.each do |move|
      dupped_board = DeepClone.clone(board)
      dupped_board.place_chip(move[1], chip)
      if dupped_board.over?
        return move[1]
      end
    end

    chip = Player.get_player_chip('red')

    valid_moves.each do |move|
      dupped_board = DeepClone.clone(board)
      dupped_board.place_chip(move[1], chip)
      if dupped_board.over?
        return move[1]
      end
    end

    row_incr = [1, 0]
    opp_row_incr = [-1, 0]
    col_incr = [0, 1]
    opp_col_incr = [0, -1]
    right_diag_incr = [1, 1]
    opp_right_diag_incr = [-1, 1]
    left_diag_incr = [1, -1]
    opp_left_diag_incr = [-1, -1]
    all_incr = [
      row_incr,
      col_incr,
      right_diag_incr,
      left_diag_incr,
      opp_row_incr,
      opp_col_incr,
      opp_right_diag_incr,
      opp_left_diag_incr
    ]

    chip = Player.get_player_chip('blue')
    valid_moves.each do |move|
      dupped_board = DeepClone.clone(board)
      dupped_board.place_chip(move[1], chip)
      all_incr.each do |incr|
        if dupped_board.check_spots(move, incr, 3)
          return move[1]
        end
      end
    end

    chip = Player.get_player_chip('red')
    valid_moves.each do |move|
      dupped_board = DeepClone.clone(board)
      dupped_board.place_chip(move[1], chip)
      all_incr.each do |incr|
        if dupped_board.check_spots(move, incr, 3)
          return move[1]
        end
      end
    end
    return valid_moves.sample[1]
  end

  def get_valid_moves(board)
    valid_moves = []
    (0...board.grid[0].length).each do |col|
      next if board.column_full?(col)
      valid_moves << board.get_first_empty_pos_in_column(col)
    end
    return valid_moves
  end
end
