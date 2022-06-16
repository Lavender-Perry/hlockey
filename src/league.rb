require_relative "./game.rb"
require_relative "./team.rb"

class League
  attr_accessor :season, :divisions, :games_in_progress

  def initialize season
    @season = season
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
        Team.new("Rio de Janeiro Gamers", "💯"),
        Team.new("Wyrzysk Rockets", "🚀")
      ],
      "Wet Cool": [
        Team.new("Cape Town Transplants", "🌱"),
        Team.new("Nagqu Paint", "🎨"),
        Team.new("Manbij Fish", "🐠"),
        Team.new("Nice Backflippers", "🔙"),
        Team.new("Orcadas Base Fog", "🌁")
      ],
      "Dry Cool": [
        Team.new("Baghdad Abacuses", "🧮"),
        Team.new("Jakarta Architects", "📐"),
        Team.new("Kyoto Payphones", "📞"),
        Team.new("Orange Thinkers", "🤔"),
        Team.new("Stony Brook Reapers", "💀")
      ]
    }
    @games_in_progress = []
    @games = []
    @prng = Random.new 69420 * season
    @shuffled_teams = @divisions.values.reduce(:+).shuffle random: @prng
    @matchup_amount = 0
    @game_in_matchup = 3
  end

  def update
    @games_in_progress = @games.select do |game| game.in_progress end
    @games_in_progress.each do |game| game.update end
  end

  def new_games
    if @game_in_matchup == 3
      @game_in_matchup = 1
      @matchup_amount += 1

      (@shuffled_teams.length / 2).times do |i|
        pair = [@shuffled_teams[i], @shuffled_teams[-i]]
        home, away = @matchup_amount > 19 ? pair : pair.reverse
        @games << Game.new(home, away, @prng)
      end

      @shuffled_teams.insert 1, @shuffled_teams.pop
      return
    end

    @games.map do |game| Game.new game.away, game.home, @prng end
    @game_in_matchup += 1
  end
end

