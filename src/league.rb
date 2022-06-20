require_relative "./game.rb"
require_relative "./team.rb"

class League
  attr_reader :day, :divisions, :games_in_progress

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
    @last_update_time = start_time
    @passed_updates = 0
    @prng = Random.new 69420 * season
    @shuffled_teams = @divisions.values.reduce(:+).shuffle random: @prng
    @game_in_matchup = 3
  end

  def update_state
    now = Time.now
    five_sec_intervals = (now - @last_update_time).floor / 5

    if five_sec_intervals > 0
      five_sec_intervals.times do |i|
        if (i + @passed_updates) % 720 == 0
          new_games
        else
          update_games
        end
      end
      @last_update_time = now
      @passed_updates += five_sec_intervals
    end
  end

  private
  def new_games
    if @game_in_matchup == 3
      @game_in_matchup = 1
      @day += 1

      (@shuffled_teams.length / 2).times do |i|
        pair = [@shuffled_teams[i], @shuffled_teams[-i]]
        home, away = @day > 19 ? pair : pair.reverse
        @games << Game.new(home, away, @prng)
      end

      @shuffled_teams.insert 1, @shuffled_teams.pop
      return
    end

    @games.map do |game| Game.new game.away, game.home, @prng end
    @game_in_matchup += 1
  end

  def update_games
    @games_in_progress = @games.select do |game| game.in_progress end
    @games_in_progress.each do |game| game.update end
  end
end

