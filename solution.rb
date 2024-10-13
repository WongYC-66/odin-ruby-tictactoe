# solution.rb
require "./lib/Game"

puts("Welcome to TicTacToe, how many rounds to play?")
game_round = gets.to_i

until game_round >= 1
  puts("Please enter valid number ")
  game_round = gets.to_i
end

new_game = Game.new(game_round)
new_game.play()

puts("Ended")