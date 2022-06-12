$random = Random.new 8010897121101114 # This never changes

class Player
  attr_accessor :name, :offense, :defense, :agility
  def initialize
    @name = random_name + " " + random_name
    @offense = $random.rand * 5
    @defense = $random.rand * 5
    @agility = $random.rand * 5
  end
end

def random_name
  len = $random.rand(9) + 2
  mod_num = if len == 2 then 2 else 3 end
  i_add = $random.rand mod_num
  name = ""

  len.times do |i|
    array = random_letter_array((i + i_add) % mod_num)
    name += array[$random.rand array.length]
  end

  name.capitalize
end

def random_letter_array(n)
  vowels = ["a", "e", "i", "o", "u"]
  consonates = ("a".."z").filter do |l| not vowels.include? l end
  case n
  when 0
    consonates
  when 1
    vowels
  else
    random_letter_array $random.rand 2
  end
end

