require_relative "./team.rb"

class League
  attr_accessor :season, :divisions

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
    @prng = Random.new 69420 * season
  end
end

