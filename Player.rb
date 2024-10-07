# Player.rb
class Player
  attr_accessor :name, :token, :score

  def initialize (name, token)
    @name = name
    @token = token
    @score = 0
  end

end