require_relative "./league.rb"

def menu_input default, *choices
  puts "Please enter a number..."
  choices.each_with_index do |choice, i|
    puts "#{i + 1} - #{choice}"
  end
  puts "anything else - #{default}"

  gets.to_i
end

season = 0
league = League.new season, Time.utc(2022, 6, 27, 17)

loop do
  league.update_state

  puts "Season #{season} day #{league.day}"

  case menu_input "Exit", "Games", "Standings", "Rosters"
  when 1 # Games
    if league.games_in_progress.empty?
      puts "There are currently no games being played."
      next
    end

    game_titles = league.games_in_progress.map do |game| game.title end

    game_idx = menu_input("Back", game_titles) - 1
    if 0 <= game_idx < game_titles.length
      game = league.games_in_progress[game_idx]
      loop do
        league.update_state

        game.stream.each do |message|
          puts message
        end

        break unless game.in_progress

        game.stream.clear
        sleep 5
      end
    end
  when 2 # Standings
    league.divisions.each do |name, teams|
      puts name
      teams.sort do |a, b| a.wins - a.losses <=> b.wins - b.losses end.each do |team|
        puts "  #{team.emoji} #{team.name.ljust 24} #{team.wins}-#{team.losses}"
      end
    end
  when 3 # Rosters
    league.divisions.values.reduce(:+).each do |team|
      puts "#{team.emoji} #{team.name}"
      team.roster.each do |pos, player|
        puts "  #{pos.to_s.ljust 6}: #{player.name}"
        player.stats.each do |stat, value|
          puts "    #{stat}: #{value.round 1}"
        end
      end
    end
  else
    exit
  end
end

