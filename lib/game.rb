# frozen_string_literal: true

require_relative('./messages')

class Game
  attr_reader(:home, :away, :stream, :in_progress)

  def initialize(home, away, prng)
    @home = home
    @away = away
    @prng = prng
    @stream = [Messages.StartOfGame(to_s)]
    @in_progress = true
    @score = { home: 0, away: 0 }
    @actions = 0
    @period = 1
    @face_off = true
    @team_with_puck = nil
    @puckless_team = nil
    @puck_holder = nil
    @shooting_chance = 0
  end

  def to_s
    "#{@home.emoji} #{@home.name} vs #{@away.name} #{@away.emoji}"
  end

  def update
    return unless @in_progress

    @stream << Messages.StartOfPeriod(@period) if @actions.zero?
    @actions += 1

    if @actions == 60
      @stream << Messages.EndOfPeriod(@period, @home.name, @away.name, *@score.values)
      @actions = 0
      @period += 1
      start_faceoff

      if @period > 3 && !(@score[:home] == @score[:away] && @period < 12)
        # Game is over
        @in_progress = false

        winner, loser = @score[:away] > @score[:home] ? [@away, @home] : [@home, @away]

        @stream << Messages.EndOfGame(winner.name)
        winner.wins += 1
        loser.losses += 1
      end
      return
    end

    if @face_off
      if @puck_holder.nil?
        # Pass opposite team to who wins the puck to switch_team_with_puck,
        # so @team_with_puck & @puckless_team are set to the correct values.
        switch_team_with_puck(if action_succeeds?(@home.roster[:center].stats[:offense],
                                                  @away.roster[:center].stats[:offense])
                                @away
                              else
                                @home
                              end)

        @puck_holder = @team_with_puck.roster[:center]
        @stream << Messages.FaceOff(@puck_holder)
      else
        pass
        @face_off = false
      end
      return
    end

    case @prng.rand 5 + @shooting_chance
    when 0..4
      pass
    when 5..6 # Check
      defender = puckless_non_goalie
      @stream << Messages.Hit(@puck_holder, defender,
                              try_take_puck(defender, 0, :defense))
    else      # Shoot
      unless @shooting_chance < 5 &&
             try_block_shot(@puckless_team.roster[@prng.rand(2).zero? ? :ldef : :rdef]) ||
             try_block_shot(@puckless_team.roster[:goalie])
        @score[@team_with_puck == @home ? :home : :away] += 1

        @stream << Messages.Shoot(@puck_holder,
                                  nil, false,
                                  @home.name, @away.name,
                                  *@score.values)

        start_faceoff
        @actions = 59 if @period > 3 # Sudden death overtime
      end
    end
  end

  private

  def action_succeeds?(helping_stat, hindering_stat)
    @prng.rand(10) + helping_stat - hindering_stat > 4
  end

  def start_faceoff
    @shooting_chance = 0
    @face_off = true
    @puck_holder = nil
  end

  def switch_team_with_puck(team_with_puck = @team_with_puck)
    @team_with_puck, @puckless_team = if team_with_puck == @home
                                        [@away, @home]
                                      else
                                        [@home, @away]
                                      end
    @shooting_chance = 0
  end

  def pass
    sender = @puck_holder
    receiver = puckless_non_goalie(@team_with_puck)
    interceptor = puckless_non_goalie

    if !@face_off && try_take_puck(interceptor, 4) # Pass intercepted
      @stream << Messages.Pass(sender, receiver, interceptor)
      return
    end

    @stream << Messages.Pass(sender, receiver)
    @puck_holder = receiver
    @shooting_chance += 1
  end

  def try_take_puck(player, dis = 0, stat = :agility)
    return false unless action_succeeds?(player.stats[stat] - dis,
                                         @puck_holder.stats[stat])

    switch_team_with_puck
    @puck_holder = player

    true
  end

  def try_block_shot(blocker)
    return false unless action_succeeds?(blocker.stats[:defense],
                                         @puck_holder.stats[:offense])

    @shooting_chance += 1
    @stream << Messages.Shoot(@puck_holder, blocker, try_take_puck(blocker))

    true
  end

  def puckless_non_goalie(team = @puckless_team)
    team.roster.values.select do |p|
      p != team.roster[:goalie] and p != @puck_holder
    end.sample(random: @prng)
  end
end
