# Board.rb
class Board 
  attr_accessor :winner_token

  PATTERN = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6]
  ]

  def initialize ()
    @board = Array.new(9, ' ')
    @winner_token = nil
  end

  def round_end?
    PATTERN.each do |locations|
      token = @board[locations[0]]
      next if token == ' '
      if locations.all? { |i| @board[i] == token}
        @winner_token = token
        return true
      end
    end

    return true if @board.count(' ') == 0   # a TIE
    return false                            # not yet finished
  end

  def place_token(location, token)
    return false if location < 0 || location >= 9
    return false if @board[location] != ' '      
    @board[location] = token
    return true
  end

  def print_board
    [0,1,2].each do |i| 
      puts (" [#{@board[i * 3]}]  [#{@board[i * 3 + 1]}]  [#{@board[i * 3 + 2]}] ") 
    end
  end

end