require_relative "./player"

class Team
  attr_accessor :wins, :losses
  attr_reader :name, :emoji, :roster

  def initialize name, emoji, roster_idxs = {:lwing  => 0,
                                             :center => 1,
                                             :rwing  => 2,
                                             :ldef   => 3,
                                             :goalie => 4,
                                             :rdef   => 5}
    @wins = 0
    @losses = 0
    @name, @emoji = [name, emoji]
    @roster = {}
    players = []
    6.times do players << Player.new end
    roster_idxs.each do |pos, i|
      @roster[pos] = players[i]
    end
  end

  def to_s
    "#{@emoji} #{@name}"
  end

  def print_win_loss
    puts "  #{to_s.ljust 26} #{@wins}-#{@losses}"
  end

  def print_roster
    puts to_s
    @roster.each do |pos, player|
      puts "  #{pos.to_s.ljust 6}: #{player.name}"
      player.stats.each do |stat, value|
        puts "    #{stat}: #{value.round 1}"
      end
    end
  end

  def self.sort_teams teams
    teams.sort do |a, b| a.wins - a.losses <=> b.wins - b.losses end
  end
end

