# frozen_string_literal: true

require_relative('./player')

class Team
  attr_accessor(:wins, :losses)
  attr_reader(:name, :emoji, :roster)

  def initialize(name, emoji, roster_idxs = { lwing: 0,
                                              center: 1,
                                              rwing: 2,
                                              ldef: 3,
                                              goalie: 4,
                                              rdef: 5 })
    @wins = 0
    @losses = 0
    @name = name
    @emoji = emoji
    players = 6.times.each_with_object([]) { |_, a| a << Player.new }
    @roster = roster_idxs.transform_values(&players.method(:[]))
  end

  def to_s
    "#{@emoji} #{@name}"
  end

  def print_win_loss
    puts("  #{to_s.ljust 26} #{@wins}-#{@losses}")
  end

  def print_roster
    puts(to_s)
    @roster.each do |pos, player|
      puts("  #{pos.to_s.ljust(6)}: #{player}")
      player.stats.each { |stat, value| puts("    #{stat}: #{value.round 1}") }
    end
  end

  def self.sort_teams(teams)
    teams.sort { |a, b| b.wins - b.losses <=> a.wins - a.losses }
  end
end
