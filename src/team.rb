require_relative "./player.rb"

class Team
  attr_reader :name, :emoji, :roster
  attr_accessor :wins, :losses

  def initialize name, emoji, roster_idxs = {:lwing  => 0,
                                             :center => 1,
                                             :rwing  => 2,
                                             :ldef   => 3,
                                             :goalie => 4,
                                             :rdef   => 5}
    @name, @emoji = [name, emoji]
    @roster = {}
    players = []
    6.times do players << Player.new end
    roster_idxs.each do |pos, i|
      @roster[pos] = players[i]
    end
    @wins = 0
    @losses = 0
  end

  def self.sort_teams teams
    teams.sort do |a, b| a.wins - a.losses <=> b.wins - b.losses end
  end
end

