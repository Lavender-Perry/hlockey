require_relative "./league.rb"
require_relative "./team.rb"

def menu_input default, *choices
  puts "Please enter a number..."
  choices.each_with_index do |choice, i|
    puts "#{i + 1} - #{choice}"
  end
  puts "anything else - #{default}"

  gets.to_i
end

season = 0
start_time = Time.utc(2022, 6, 27, 17).localtime

if Time.now < start_time
  puts start_time.strftime "Season #{season} will start at %H:%M on %A, %B %d."
  exit
end

league = League.new season, start_time

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

        game.stream.each &method(:puts)

        break unless game.in_progress

        game.stream.clear
        sleep 5
      end
    end
  when 2 # Standings
    print_in_standings = Proc.new do |team|
      puts "  #{team.emoji} #{team.name.ljust 24} #{team.wins}-#{team.losses}"
    end

    if league.champion_team
      puts "Your season #{season} champions are the #{champion_team.name}!"
    elsif league.playoff_teams
      puts "Playoffs"
      league.playoff_teams.each &print_in_standings
    end

    league.divisions.each do |name, teams|
      puts name
      Team.sort_teams(teams).each &print_in_standings
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

