# frozen_string_literal: true

require('yaml')
require_relative('./game')

class League
  attr_reader(:divisions, :day, :games_in_progress, :playoff_teams, :champion_team)

  class Team
    private_class_method(:new)

    attr_accessor(:wins, :losses)
    attr_reader(:name, :emoji, :roster)

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

    def self.sort(teams)
      teams.sort { |a, b| b.wins - b.losses <=> a.wins - a.losses }
    end
  end

  def initialize(season, start_time)
    # The YAML file is included with the program,
    # so this is as safe as anything else
    @divisions = YAML.unsafe_load_file(File.expand_path('data/divisions.yaml',
                                                        File.dirname(__FILE__)))

    @day = 0
    @games_in_progress = []
    @games = []
    @champion_team = nil
    @last_update_time = start_time
    @passed_updates = 0
    @prng = Random.new(69_420 * season)
    @shuffled_teams = @divisions.values.reduce(:+).shuffle(random: @prng)
    @playoff_teams = nil
    @game_in_matchup = 3
  end

  def update_state
    return if @champion_team

    now = Time.at(Time.now.to_i)
    five_sec_intervals = (now - @last_update_time).div(5)

    return unless five_sec_intervals.positive?

    five_sec_intervals.times do |i|
      if ((i + @passed_updates) % 720).zero?
        new_games
      else
        update_games
      end

      break if @champion_team
    end

    @last_update_time = now
    @passed_updates += five_sec_intervals
  end

  private

  def new_games
    if @game_in_matchup != (@day > 38 ? 5 : 3)
      # New game in matchups
      @games.map! { |game| Game.new(game.away, game.home, @prng) }
      @game_in_matchup += 1
      return
    end

    # New matchups
    @games.clear
    @game_in_matchup = 1
    @day += 1

    case @day <=> 39
    when -1
      (@shuffled_teams.length / 2).times do |i|
        pair = [@shuffled_teams[i], @shuffled_teams[-i - 1]]
        @games << Game.new(*(@day > 19 ? pair : pair.reverse), @prng)
      end

      @shuffled_teams.insert 1, @shuffled_teams.pop
    when 0
      @playoff_teams = Team.sort(
        @divisions.values.map do |teams|
          Team.sort(teams).first(2)
        end.reduce(:+)
      ).map(&:clone)

      new_playoff_matchups
    when 1
      @playoff_teams = Team.sort(@playoff_teams).first(@playoff_teams.length / 2)

      if @playoff_teams.length == 1
        @champion_team = @playoff_teams[0]
        return
      end

      new_playoff_matchups
    end
  end

  def update_games
    @games_in_progress.each(&:update)
    @games_in_progress = @games.select(&:in_progress)
  end

  def new_playoff_matchups
    @playoff_teams.each do |team|
      team.wins = 0
      team.losses = 0
    end

    (0...@playoff_teams.length).step(2) do |i|
      @games << Game.new(*@playoff_teams[i, 2], @prng)
    end
  end

  class Player
    private_class_method(:new)

    attr_reader(:stats, :to_s)
  end
end
