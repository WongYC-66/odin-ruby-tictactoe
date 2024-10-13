# Game.rb
require_relative 'Board'
require_relative 'Player'

class Game

  def initialize (round, board = Board.new, player1 = Player.new("Player_1", "O"), player2 = Player.new("Player_2", "X"))
    @board = board
    @turn = true      # true = Player_1, # false = Player_2
    @max_round = round
    @curr_round = 1
    @player1 = player1
    @player2 = player2
  end

  def new_round
    @turn = true
    @board = Board.new
    @board.print_board
  end

  def game_end?
    return @curr_round > @max_round 
  end

  def ask_and_place
    curr_turn_player = @turn ? @player1 : @player2
    puts "#{curr_turn_player.name}'s turn, please enter location (1~9) : "
    location_input = gets.to_i - 1
    res = @board.place_token(location_input, curr_turn_player.token)
    @turn = !@turn  if res
  end

  def play 
    new_round()

    while(!game_end?())   # game not ended
      print_game_status()
      ask_and_place()
      @board.print_board
      check_round_end()
    end

    # game fully ended
    print_game_result()
  end

  def check_round_end
    if @board.round_end?
      @curr_round += 1
      if(@board.winner_token == nil)    #tie
        puts "It's a tie, nobody has won"
      else
        winning_player = @board.winner_token == "O" ? @player1 : @player2
        winning_player.score += 1 
        puts("#{winning_player.name} got it!")
      end
      # reinitialize
      new_round()
    end
  end

  def print_game_result
    print_game_status()
    if @player1.score == @player2.score
      puts "Game Ended. No winner, it's a tie!"
    elsif @player1.score > @player2.score
      puts "Game Ended. Winner : Player 1!"
    else
      puts "Game Ended. Winner : Player 2!"
    end
  end

  def print_game_status
    puts "P1: #{@player1.score} , P2: #{@player2.score}, ROUND: #{@curr_round}/#{@max_round}"
  end

end