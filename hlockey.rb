#!/usr/bin/env ruby

require_relative "./lib/league"
require_relative "./lib/team"

def menu_input default, *choices
  puts "Please enter a number..."
  choices.each_with_index do |choice, i|
    # Adding 1 to i to avoid confusing a non-numerical input with the first choice
    puts "#{(i + 1).to_s.rjust 2} - #{choice}"
  end
  puts "anything else - #{default}"

  # Subtract 1 here to undo adding 1 earlier
  gets.to_i - 1
end

# Each element from choices should implement to_s
def menu_input_elem default, choices
  i = menu_input default, *choices
  choices[i] unless i < 0
end

season = 0
start_time = Time.utc(2022, 6, 27, 17).localtime
league = League.new season, start_time

if Time.now < start_time
  puts start_time.strftime "Season #{season} starts at %H:%M on %A, %B %d."
end

loop do
  league.update_state

  puts "Season #{season} day #{league.day}"

  case menu_input "Exit", "Games", "Standings", "Rosters"
  when 0 # Games
    if league.games_in_progress.empty?
      puts "There are currently no games being played."
      next
    end

    game = menu_input_elem "Back", league.games_in_progress
    next if game.nil?

    loop do
      league.update_state

      game.stream.each &method(:puts)

      break unless game.in_progress

      game.stream.clear
      sleep 5
    end
  when 1 # Standings
    if league.champion_team
      puts "Your season #{season} champions are the #{champion_team.name}!"
    elsif league.playoff_teams
      puts "Playoffs"
      league.playoff_teams.each &:print_win_loss
    end

    league.divisions.each do |name, teams|
      puts name
      Team.sort_teams(teams).each &:print_win_loss
    end
  when 2 # Rosters
    teams = league.divisions.values.reduce(:+)
    team = menu_input_elem "All teams", teams
    
    if team.nil?
      teams.each &:print_roster
      next
    end
    team.print_roster
  else
    exit
  end
end

