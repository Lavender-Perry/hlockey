# frozen_string_literal: true

require('hlockey/data')
require('hlockey/game')
require('hlockey/team')
require('hlockey/version')

module Hlockey
  class League
    attr_reader(:start_time, :divisions, :teams, :day,
                :games, :games_in_progress, :playoff_teams, :champion_team)

    def initialize
      @start_time, @divisions = Hlockey.load_data('league')
      @start_time.localtime
      @day = 0
      @games_in_progress = []
      @games = []
      @champion_team = nil
      @last_update_time = @start_time
      @passed_updates = 0
      @prng = Random.new(69_420 * VERSION.to_i)
      @teams = @divisions.values.reduce(:+)
      @shuffled_teams = teams.shuffle(random: @prng)
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
        @playoff_teams = sort_teams_by_wins(
          @divisions.values.map do |teams|
            sort_teams_by_wins(teams).first(2)
          end.reduce(:+)
        ).map(&:clone)

        new_playoff_matchups
      when 1
        @playoff_teams.select! { |team| team.wins > team.losses }

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
      @divisions.transform_values!(&method(:sort_teams_by_wins))
    end

    def new_playoff_matchups
      @playoff_teams.each do |team|
        team.wins = 0
        team.losses = 0
      end

      (@playoff_teams.length / 2).times do |i|
        @games << Game.new(@playoff_teams[i], @playoff_teams[-i - 1], @prng)
      end
    end

    class Player
      private_class_method(:new)
      attr_reader(:stats, :to_s)
    end
  end
end

def sort_teams_by_wins(teams)
  teams.sort { |a, b| b.wins <=> a.wins }
end
