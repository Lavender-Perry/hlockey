require_relative "./player.rb"

class Team
  attr_accessor :name, :emoji, :wins, :losses, :roster
  def initialize name, emoji, roster_idxs = {:lwing  => 0,
                                             :center => 1,
                                             :rwing  => 2,
                                             :ldef   => 3,
                                             :goalie => 4,
                                             :rdef   => 5}
    @name, @emoji = [name, emoji]
    @wins = 0
    @losses = 0
    @roster = {}
    players = []
    6.times do players << Player.new end
    roster_idxs.each do |pos, i|
      @roster[pos] = players[i]
    end
    @roster[:non_goalies] = players.select do |p| p != @roster[:goalie] end
  end
end

