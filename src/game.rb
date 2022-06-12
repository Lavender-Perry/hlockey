class Game
  attr_accessor :home, :away, :score, :stream

  def initialize(home, away)
    @home = home
    @away = away
    @score = {
      :home => 0,
      :away => 0
    }
    @stream = ["*whistle blow*"]
    @face_off = true
    @team_with_puck = nil
    @puck_holder = nil
  end

  def update(prng)
    if @face_off then
      if @puck_holder == nil then
        h_center = @home.roster[:center]
        a_center = @away.roster[:center]
        @team_with_puck = prng.rand(10) + (h_center.offense - a_center.offense) > 4 ?
          @home : @away
        @puck_holder = @team_with_puck.roster[:center]
        @stream << @puck_holder.name + " wins the faceoff!"
      else
        pass @team_with_puck.roster[prng.rand 2 == 1 ? :lwing : :rwing]
        @face_off = false
      end
    else
      # TODO
    end
  end

  private
  def pass(player, intercept = false)
    @stream << intercept ?
      "#{player.name} intercepts pass by #{@puck_holder.name}!" :
      "#{@puck_holder.name} passes to #{player.name}."
    switch_team_with_puck if intercept
    @puck_holder = player
  end

  def switch_team_with_puck
    @team_with_puck = @team_with_puck == @home ? @away : @home
  end
end

