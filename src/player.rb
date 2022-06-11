$random = Random.new 8010897121101114

def player_name
  vowels = ["a", "e", "i", "o", "u", "y"]
  consonates = ("a".."z").filter do |l| not vowels.include? l end
  fname_length = $random.rand(7) + 3
  lname_length = $random.rand(7) + 3
  name = ""
  add_rand_letter = Proc.new do |i|
    array = if i % 2 == 0 then consonates else vowels end
    name += array[$random.rand array.length]
  end

  fname_length.times &add_rand_letter
  name += " "
  lname_length.times &add_rand_letter

  name.split.map do |n| n.capitalize end.join " "
end

class Player
  attr_accessor :name, :offense, :defense, :agility
  def initialize
    @name = player_name
    @offense = $random.rand * 5
    @defense = $random.rand * 5
    @agility = $random.rand * 5
  end
end

