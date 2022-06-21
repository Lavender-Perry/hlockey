require_relative "./game"
require_relative "./team"

class League
  attr_reader :day, :divisions, :games_in_progress, :playoff_teams, :champion_team

  def initialize season, start_time
    @day = 0
    @divisions = {
      "Wet Warm": [
        Team.new("Antalya Pirates", "🌊"),
        Team.new("Baden Hallucinations", "🍄"),
        Team.new("Kópavogur Seals", "🦭"),
        Team.new("Lagos Soup", "🥣"),
        Team.new("Pica Acid", "🧪")
      ],
      "Dry Warm": [
        Team.new("Dawson City Impostors", "🔪"),
        Team.new("Erlangen Ohms", "🇴"),
        Team.new("Pompei Eruptions", "🌋"),
        Team.new("Rio de Janeiro Directors", "🎦"),
        Team.new("Wyrzysk Rockets", "🚀")
      ],
      "Wet Cool": [
        Team.new("Cape Town Transplants", "🌱"),
        Team.new("Manbij Fish", "🐠"),
        Team.new("Nagqu Paint", "🎨"),
        Team.new("Nice Backflippers", "🔄"),
        Team.new("Orcadas Base Fog", "🌁")
      ],
      "Dry Cool": [
        Team.new("Baghdad Abacuses", "🧮"),
        Team.new("Jakarta Architects", "📐"),
        Team.new("Kyoto Payphones", "📳"),
        Team.new("Stony Brook Reapers", "💀"),
        Team.new("Sydney Thinkers", "🤔")
      ]
    }
    @games_in_progress = []
    @games = []
    @champion_team = nil
    @last_update_time = start_time
    @passed_updates = 0
    @prng = Random.new 69420 * season
    @shuffled_teams = @divisions.values.reduce(:+).shuffle random: @prng
    @playoff_teams = nil
    @game_in_matchup = 3
  end

  def update_state
    return if @champion_team

    now = Time.now
    five_sec_intervals = (now - @last_update_time).floor / 5

    if five_sec_intervals > 0
      five_sec_intervals.times do |i|
        if (i + @passed_updates) % 720 == 0
          new_games
        else
          update_games
        end

        return if @champion_team
      end

      @last_update_time = now
      @passed_updates += five_sec_intervals
    end
  end

  private
  def new_games
    if @game_in_matchup != (@day > 38 ? 5 : 3)
      # New game in matchups
      @games.map! do |game| Game.new(game.away, game.home, @prng) end
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
        pair = [@shuffled_teams[i], @shuffled_teams[-i]]
        @games << Game.new(*(@day > 19 ? pair : pair.reverse), @prng)
      end

      @shuffled_teams.insert 1, @shuffled_teams.pop
    when 0
      @playoff_teams = Team.sort_teams(
        @divisions.values.map do |teams|
          Team.sort_teams(teams).first(2)
        end.reduce(:+).map &:copy
      )

      new_playoff_matchups
    when 1
      @playoff_teams = Team.sort_teams(@playoff_teams).first(@playoff_teams.length / 2)

      if @playoff_teams.length == 1
        @champion_team = @playoff_teams[0]
        return
      end

      new_playoff_matchups
    end
  end

  def update_games
    @games_in_progress = @games.select do |game| game.in_progress end
    @games_in_progress.each do |game| game.update end
  end

  def new_playoff_matchups
    @playoff_teams.each do |team|
      team.wins = 0
      team.losses = 0
    end

    (0...@playoff_teams.length).step 2 do |i|
      @games << Game.new(*@playoff_teams[i, 2], @prng)
    end
  end
end

