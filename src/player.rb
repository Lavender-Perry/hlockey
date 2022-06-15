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
    len = @@prng.rand(9) + 2
    mod_num = len == 2 ? 2 : 3
    i_add = @@prng.rand mod_num
    name = ""

    len.times do |i| name += random_letter (i + i_add) % mod_num end

    name.capitalize
  end

  def random_letter n
    vowels = ["a", "e", "i", "o", "u"]
    consonates = ("a".."z").filter do |l| not vowels.include? l end
    case n
    when 0
      consonates
    when 1
      vowels
    else
      @@prng.rand(2) == 0 ? consonates : vowels
    end.sample random: @@prng
  end
end
