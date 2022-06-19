class Game
  attr_accessor :title, :stream, :in_progress

  def initialize home, away, prng
    @title = "#{home.emoji} #{home.name} vs #{away.name} #{away.emoji}"
    @stream = ["*whistle blow*"]
    @in_progress = true
    @home, @away, @prng = [home, away, prng]
    @score = {
      :home => 0,
      :away => 0
    }
    @actions = 0
    @period = 1
    @face_off = true
    @team_with_puck = nil
    @puckless_team = nil
    @puck_holder = nil
    @shooting_chance = 0
  end

  def update
    return unless @in_progress

    if @actions == 60
      @stream << "End of period #{@period}."
      report_score
      @actions = 0
      @period += 1

      if @period > 3 and not(@score[:home] == @score[:away] and @period < 12)
        @stream << "Game over."
        @in_progress = false

        winner, loser = case @score[:home] <=> @score[:away]
                        when 1
                          [@home, @away]
                        when -1
                          [@away, @home]
                        when 0
                          @stream << "Nobody wins."
                          @home.losses += 1
                          @away.losses += 1
                          return
                        end

        @stream << winner.name + " wins!"
        winner.wins += 1
        loser.losses += 1
      end
      return
    end

    @stream << "Start of period #{@period}." if @actions == 0

    @actions += 1

    if @face_off
      if @puck_holder == nil
        # Pass opposite team to who wins the puck to switch_team_with_puck,
        # so @team_with_puck & @puckless_team are set to the correct values.
        switch_team_with_puck(
          action_succeeds?(@home.roster[:center].offense,
                           @away.roster[:center].offense) ? @away : @home)

        @puck_holder = @team_with_puck.roster[:center]
        @stream << @puck_holder.name + " wins the faceoff!"
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
      @stream << "#{defender.name} hits #{@puck_holder.name}!"
      try_take_puck defender
    else
      shoot
    end
  end

  private
  def action_succeeds? helping_stat, hindering_stat
    @prng.rand(10) + helping_stat - hindering_stat > 4
  end

  def switch_team_with_puck team_with_puck = @team_with_puck
    @team_with_puck, @puckless_team = team_with_puck == @home ?
      [@away, @home] : [@home, @away]
    @shooting_chance = 0
    @stream << @team_with_puck + " has possession."
  end

  def pass
    @stream << @puck_holder.name + " sends a pass."

    unless not @face_off and try_take_puck puckless_non_goalie, 2
      receiver = puckless_non_goalie @team_with_puck
      @stream << receiver.name + " receives the pass."
      @puck_holder = receiver
      @shooting_chance += 1
    end
  end

  def shoot
    @stream << @puck_holder.name + " takes a shot!"

    unless @shooting_chance < 5 and
        try_block_shot @puckless_team.roster[@prng.rand(2) == 0 ? :ldef : :rdef] or
        try_block_shot @puckless_team.roster[:goalie]
      @stream << @puck_holder.name + " scores!"
      @score[@team_with_puck == @home ? :home : :away] += 1
      report_score
      @shooting_chance = 0
      @face_off = true
      @actions = 60 if @period > 3 # Sudden death overtime
    end
  end

  def report_score
    @stream << "#{@home.name} #{@score[:home]}, #{@away.name} #{@score[:away]}."
  end

  def try_take_puck player, disadvantage = 0
    if action_succeeds? player.agility - disadvantage, @puck_holder.agility
      @stream << player.name + " takes the puck!"
      switch_team_with_puck
      @puck_holder = player
      return true
    end
    false
  end

  def try_block_shot player
    if action_succeeds? player.defense, @puck_holder.offense
      @stream << player.name + " blocks the shot!"
      @shooting_chance += 1
      try_take_puck player
      return true
    end
    false
  end

  def puckless_non_goalie team = @puckless_team
    team.roster.values.select do |p|
      p != team.roster[:goalie] and p != @puck_holder
    end.sample random: @prng
  end
end

