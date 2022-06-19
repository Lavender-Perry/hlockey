require_relative "./league.rb"

season = 0
league = League.new season
season_start_time = Time.utc 2022, 6, 20, 17
last_update_time = season_start_time
passed_actions = 0

def menu_input default, *choices
  puts "Please enter a number..."
  choices.each_with_index do |choice, i|
    puts "#{i + 1} - #{choice}"
  end
  puts "anything else - #{default}"

  gets.to_i
end

loop do
  now = Time.now
  five_sec_intervals = (now - last_update_time).floor / 5
  if five_sec_intervals > 0
    five_sec_intervals.times do |i|
      if (i + passed_actions) % 720 == 0
        league.new_games
      else
        league.update
      end
    end
    last_update_time = now
    passed_actions += five_sec_intervals
  end

  puts "Season #{season} day #{league.day}"

  case menu_input "Exit", "Games", "Standings", "Rosters"
  when 1 # Games
    if league.games_in_progress.empty?
      puts "There are currently no games being played."
      next
    end

    game_titles = league.games_in_progress.map do |game| game.title end

    if 1 <= menu_input("Back", game_titles) <= game_titles.length
      # TODO: watching the game
    end
  when 2 # Standings
    league.divisions.each do |name, teams|
      puts name
      teams.sort do |a, b| a.wins - a.losses <=> b.wins - b.losses end.each do |team|
        puts "    #{team.emoji} #{team.name.ljust 24} #{team.wins}-#{team.losses}"
      end
    end
  when 3 # Rosters
    league.divisions.values.reduce(:+).each do |team|
      puts "#{team.emoji} #{team.name}"
      team.roster.each do |pos, player|
        puts "    #{pos.to_s.ljust 6}: #{player.name}"
        # TODO: put stats
      end
    end
  else   # Exit
    exit
  end
end

