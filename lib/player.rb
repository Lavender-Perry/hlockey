require_relative "./data/names_markov_chain"

class Player
  attr_reader :stats, :to_s

  @@prng = Random.new 8010897121101114 # This never changes

  def initialize
    @to_s = random_name + " " + random_name
    @stats = [:offense, :defense, :agility].each_with_object Hash.new do |stat, hash|
      hash[stat] = @@prng.rand * 5
    end
  end

  private
  def random_name
    combination = "__"
    next_letter = ""
    result = ""

    10.times do
      next_letters = NamesMarkovChain[combination]
      break if next_letters.nil?

      cumulative_weights = []
      next_letters.values.each do |v|
        cumulative_weights << v + (cumulative_weights.last or 0)
      end
      rand_num = @@prng.rand cumulative_weights.last

      next_letter = next_letters.keys[cumulative_weights.index do |n| rand_num < n end]
      break if next_letter == "_"

      result += next_letter
      combination = combination[1] + next_letter
    end
    
    result
  end
end

