class Game
  attr_accessor :home, :away, :score, :stream

  def initialize home, away, prng
    @home, @away, @prng = [home, away, prng]
    @score = {
      :home => 0,
      :away => 0
    }
    @stream = ["*whistle blow*"]
    @face_off = true
    @team_with_puck = nil
    @team_without_puck = nil
    @puck_holder = nil
    @shooting_chance = 0
  end

  def update
    if @face_off then
      if @puck_holder == nil then
        # Pass opposite team to who wins the puck to switch_team_with_puck,
        # so @team_with_puck & @team_without_puck are set to the correct values.
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
    when 0..5
      pass
    when 6 # Check
      defender = non_goalie_opponent
      stream << "#{defender.name} hits #{@puck_holder.name}!"
      try_take_puck defender
    else   # Shoot
      stream << @puck_holder.name + " takes a shot!"

      return if @shooting_chance < 5 and
        try_block @team_without_puck.roster[@prng.rand(2) == 0 ? :ldef : :rdef]

      try_block @team_without_puck.roster[:goalie]
    end
  end

  private
  def action_succeeds? helping_stat, hindering_stat
    @prng.rand(10) + helping_stat - hindering_stat > 4
  end

  def switch_team_with_puck team_with_puck = @team_with_puck
    @team_with_puck, @team_without_puck = team_with_puck == @home ?
      [@away, @home] : [@home, @away]
    @shooting_chance = 0
  end

  def pass
    stream << @puck_holder.name + " sends a pass."

    return if not @face_off and try_take_puck non_goalie_opponent, 2

    receiver = @team_with_puck.roster[:non_goalies].select do |player|
      player != @puck_holder
    end.sample @prng

    @stream << receiver.name + " receives the pass."
    @puck_holder = receiver
    @shooting_chance += 1
  end

  def try_take_puck player, disadvantage = 0
    if action_succeeds? player.agility - disadvantage, @puck_holder.agility then
      stream << player.name + " takes the puck!"
      switch_team_with_puck
      @puck_holder = player
      return true
    end
    false
  end

  def try_block_shot player
    if action_succeeds? player.defense, @puck_holder.offense then
      stream << player.name + " blocks the shot!"
      @shooting_chance += 1
      try_take_puck player
      return true
    end
    false
  end

  def non_goalie_opponent
    @team_without_puck.roster[:non_goalies].sample @prng
  end
end

