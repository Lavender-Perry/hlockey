require_relative "./team.rb"

class League
  attr_accessor :season, :divisions, :prng
  def initialize(season)
    @season = season
    @divisions = {
      "Wet Warm": [
        Team.new("Antalya Pirates", "🌊"),
        Team.new("Baden Hallucinations", "🍄"),
        Team.new("Lagos Soup", "🥣"),
        Team.new("Pica Acid", "🧪")
      ],
      "Dry Warm": [
        Team.new("Erlangen Ohms", "🇴"),
        Team.new("Pompei Eruptions", "🌋"),
        Team.new("Rio de Janeiro Gamers", "💯"),
        Team.new("Wyrzysk Rockets", "🚀")
      ],
      "Wet Cool": [
        Team.new("Cape Town Transplants", "🌱"),
        Team.new("Manbij Fish", "🐠"),
        Team.new("Nice Backflippers", "🔙"),
        Team.new("Orcadas Base Fog", "🌁")
      ],
      "Dry Cool": [
        Team.new("Baghdad Abaci", "🧮"),
        Team.new("Dawson City Impostors", "🔪"),
        Team.new("Jakarta Architects", "📐"),
        Team.new("Stony Brook Reapers", "💀")
      ]
    }
    @prng = Random.new 69420 * season
  end
end

