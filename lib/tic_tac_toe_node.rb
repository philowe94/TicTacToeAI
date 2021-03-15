require_relative 'tic_tac_toe'


class TicTacToeNode

  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
    @children = nil
    if @next_mover_mark == :x
      current_mover_mark = :o
    else
      current_mover_mark = :x
    end
    @current_mover_mark = current_mover_mark
  end

  #evaluator is the mark of the current player
  def losing_node?(evaluator)
# Base case: the board is over AND
#     If winner is the opponent, this is a losing node.
#     If winner is nil or us, this is not a losing node.
    return true if @board.over? && @board.winner == @next_mover_mark
    return false if @board.over? && @board.winner != @next_mover_mark

# Recursive case:
#     It is the player's turn, and all the children nodes are losers for the player 
#     (anywhere they move they still lose), OR
#     It is the opponent's turn, and one of the children nodes is a losing node for 
#     the player (assumes your opponent plays perfectly; they'll force you to lose if they can).
    #next_mover_mark is :x
    #the current player is :o

    #
    if evaluator != @next_mover_mark
      return @children.all? { |child| child.losing_node?(evaluator)}
    else
      return @children.any? { |child| child.losing_node?(evaluator)}
    end
  end

  def winning_node?(evaluator)
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  # Nodes
  def children
    children = []

    @board.rows.each_with_index do |row, row_idx|
      row.each_with_index do |mark, col_idx|

        if @board.empty?([row_idx, col_idx])

          duped_board = @board.dup
          duped_board[[row_idx, col_idx]]= @next_mover_mark
          if @next_mover_mark == :x
            childmark = :o
          else
            childmark = :x
          end
          child = TicTacToeNode.new(duped_board, childmark, [row_idx, col_idx])
          children << child
        end
      end
    end
    @children = children
    return children
  end
end
