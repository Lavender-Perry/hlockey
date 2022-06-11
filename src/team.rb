require_relative "./player.rb"

class Team
  attr_accessor :name, :emoji, :wins, :losses, :offense, :defense
  def initialize(name, emoji)
    @name = name
    @emoji = emoji
    @wins = 0
    @losses = 0
    @offense = []
    @defense = []
    3.times do @offense << Player.new end
    3.times do @defense << Player.new end
  end
end

