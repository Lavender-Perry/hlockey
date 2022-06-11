$random = Random.new 8010897121101114

class Player
  attr_accessor :name, :offense, :defense, :agility
  def initialize
    @name = player_name
    @offense = $random.rand * 5
    @defense = $random.rand * 5
    @agility = $random.rand * 5
  end
end

def player_name
  fname_length = $random.rand(9) + 2
  lname_length = $random.rand(9) + 2
  fname = ""
  lname = ""

  fname_length.times do |i| fname += random_letter i end
  lname_length.times do |i| lname += random_letter i end

  fname.capitalize + " " + lname.capitalize
end

def random_letter(i)
  array = random_letter_array i % 3
  array[$random.rand array.length]
end

def random_letter_array(n)
  vowels = ["a", "e", "i", "o", "u", "y"]
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

