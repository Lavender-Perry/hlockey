# frozen_string_literal: true

module Season
  NUMBER = 1
  START_TIME = Time.utc(2022, 7, 4, 17).localtime.freeze
  ELECTION = {
    'Bribery': {
      'Eat More RAM': 'Add an online interface to the league.',
      'Weather': 'Move all the stadiums outdoors.',
      'We Do A Little Losing': 'Recognize the losingest teams with an Underbracket.'
    },
    'Treasure': {
      'Vengence': 'All your team\'s stats are boosted by your team\'s losses * 0.005.',
      'Dave': 'The worst stat on your team is set to 4.5.',
      'Nice': 'Boost your worst player by 0.69 in every stat.',
      'Convenient Math Error': 'Your team starts the next season with 5 wins.'
    },
    'Coaching': {
      'Player Swapping': 'Swap the positions of 2 players on your team.',
      'Stat Swapping': 'Swap 2 stats of a player on your team.',
      'Draft': 'Replace a player with a random new player.',
      'Small Gamble': 'All your team\'s stats go up or down by 0.5 at random.',
      'Big Gamble': 'All your team\'s stats go up or down by 1.0 at random.'
    }
  }.freeze
  ELECTION_FORM = 'https://forms.gle/saLp3ucxg2ERsY9L7'
end
