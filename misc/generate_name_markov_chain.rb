# Generates the data in /src/data/name_markov_chain.rb,
# output is redirected there to create that file.
# Uses a file from https://github.com/smashew/NameDatabases as its source

require "open-uri"

NamesFile = "https://raw.githubusercontent.com/smashew/NameDatabases/master/NamesDatabases/first%20names/us.txt"

hash = URI.open(NamesFile).each_with_object Hash.new do |name, hash|
  name = "__#{name.strip}__"
  (name.length - 3).times do |i|
    combination = name[i, 2]
    next_letter = name[i + 2]
    hash[combination] = {} unless hash.include? combination
    hash[combination][next_letter] = 0 unless hash[combination].include? next_letter
    hash[combination][next_letter] += 1
  end
end

puts "# This file was automatically generated by /misc/generate_name_markov_chain.rb"
puts "NamesMarkovChain = " + hash.to_s.gsub(/},/, "},\n")
