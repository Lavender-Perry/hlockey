class Game
  attr_accessor :home, :away, :score, :stream, :game_ended

  def initialize home, away, prng
    @home, @away, @prng = [home, away, prng]
    @score = {
      :home => 0,
      :away => 0
    }
    @stream = ["*whistle blow*"]
    @game_ended = false
    @actions = 0
    @period = 1
    @face_off = true
    @team_with_puck = nil
    @team_without_puck = nil
    @puck_holder = nil
    @shooting_chance = 0
  end

  def update
    return if @game_ended

    if @actions == 20 then
      @stream << "End of period #{@period}."
      report_score
      @actions = 0
      @period += 1

      if @period >= 4 then
        shootouts = 0
        while @score[:home] == @score[:away] do
          if @period == 4 then
            @stream << "Overtime..."
            return
          end

          if shootouts == 3 then
            @stream << "Both teams are too tired to continue."
            @stream << "Game over."
            @stream << "Nobody wins."
            [@home, @away].each do |t| t.losses += 1 end
            @game_ended = true
            return
          end

          @stream << "The game is still tied."
          @stream << "Shootout..."
          @shooting_chance = 10
          [@home, @away].each do |t|
            players_who_shot = []
            3.times do
              @puck_holder = t.roster[:non_goalies].select do |p|
                not players_who_shot.include? p
              end
              players_who_shot << @puck_holder
              shoot
            end
          end
          shootouts += 1
        end

        @stream << "Game over."
        winner, loser = @score[:home] > @score[:away] ? [@home, @away] : [@away, @home]
        @stream << winner.name + " wins!"
        winner.wins += 1
        loser.losses += 1
        @game_ended = true
      end
      return
    end

    @stream << "Start of period #{@period}." if @actions == 0

    @actions += 1

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
    when 0..4
      pass
    when 5..6 # Check
      defender = non_goalie_opponent
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
    @team_with_puck, @team_without_puck = team_with_puck == @home ?
      [@away, @home] : [@home, @away]
    @shooting_chance = 0
  end

  def pass
    @stream << @puck_holder.name + " sends a pass."

    return if not @face_off and try_take_puck non_goalie_opponent, 2

    receiver = @team_with_puck.roster[:non_goalies].select do |p| p != @puck_holder end
      .sample random: @prng

    @stream << receiver.name + " receives the pass."
    @puck_holder = receiver
    @shooting_chance += 1
  end

  def shoot
    @stream << @puck_holder.name + " takes a shot!"

    return if @shooting_chance < 5 and
      try_block_shot @team_without_puck.roster[@prng.rand(2) == 0 ? :ldef : :rdef]

    unless try_block_shot @team_without_puck.roster[:goalie] then
      @stream << @puck_holder.name + " scores!"
      @score[@team_with_puck == @home ? :home : :away] += 1
      report_score
      @shooting_chance = 0
      @face_off = true
      @actions = 20 if @period == 4 # Sudden death overtime
    end
  end

  def report_score
    @stream << "#{@home.name} #{@score[:home]}, #{@away.name} #{@score[:away]}."
  end

  def try_take_puck player, disadvantage = 0
    if action_succeeds? player.agility - disadvantage, @puck_holder.agility then
      @stream << player.name + " takes the puck!"
      switch_team_with_puck
      @puck_holder = player
      return true
    end
    false
  end

  def try_block_shot player
    if action_succeeds? player.defense, @puck_holder.offense then
      @stream << player.name + " blocks the shot!"
      @shooting_chance += 1
      try_take_puck player
      return true
    end
    false
  end

  def non_goalie_opponent
    @team_without_puck.roster[:non_goalies].sample random: @prng
  end
end

