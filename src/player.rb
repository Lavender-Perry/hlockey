class Player
  attr_accessor :name, :offense, :defense, :agility

  @@prng = Random.new 8010897121101114 # This never changes

  def initialize
    @name = random_name + " " + random_name
    @offense = @@prng.rand * 5
    @defense = @@prng.rand * 5
    @agility = @@prng.rand * 5
  end

  private
  def random_name
    vowels = ["a", "e", "i", "o", "u"]
    consonates = ("a".."z").filter do |l| not vowels.include? l end

    # Starting letter should be chosen randomly from every letter,
    # so that each vowel isn't more likely to be the first letter than each consonate.
    name = (vowels + consonates).sample random: @@prng

    added_letters = @@prng.rand(7) + 1
    return name.upcase + (vowels.include?(name) ? consonates : vowels)
      .sample(random: @@prng) if added_letters == 1

    # To avoid 3 vowels/consonates in a row:
    # If the starting letter is a vowel, it should not be mode 0
    # If it is a consonate, it should not be mode 2
    mode = vowels.include?(name) ? @@prng.rand(3) + 1 : (@@prng.rand(3) + 3) % 4

    added_letters.times do
      name += (mode / 2 == 0 ? vowels : consonates).sample random: @@prng
      mode = mode % 2 == 0 ? mode + 1 : @@prng.rand(2) + 3 - mode
    end

    name.capitalize
  end
end

