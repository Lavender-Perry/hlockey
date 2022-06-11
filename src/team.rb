require_relative "./player.rb"

class Team
  attr_accessor :name, :offense, :defense
  def initialize(name)
    @name = name
    @offense = []
    @defense = []
    3.times do @offense << Player.new end
    3.times do @defense << Player.new end
  end
end

