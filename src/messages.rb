class Messages
  def initialize event, fields, data
    @event = event
    data_fields.zip data do |(f, d)|
      instance_variable_set "@" + f, d
    end
  end

  private_class_method :new

  [
    [:StartOfGame, :title],
    [:EndOfGame, :winning_team],
    [:StartOfPeriod, :period],
    [:EndOfPeriod, :period, :home, :away, :home_score, :away_score],
    [:FaceOff, :winning_player],
    [:Hit, :puck_holder, :defender, :puck_taken],
    [:Pass, :sender, :receiver, :interceptor],
    [:Shoot, :shooter, :blocker, :puck_taken, :home, :away, :home_score, :away_score]
  ].each do |event, *fields|
    define_method event do |*data|
      new event, fields, data
    end
  end

  def to_s
    case @event
    when :StartOfGame
      @title + "\nHocky!"
    when :EndOfGame
      "Game over.\n#{@winning_team or "Nobody"} wins!"
    when :StartOfPeriod
      "Start" + of_period
    when :EndOfPeriod
      "End" + of_period + score
    when :FaceOff
      @winning_player + " wins the faceoff!"
    when :Hit
      "#{@defender} hits #{@puck_holder + takes}!"
    when :Pass
      "#{@sender} passes to #{@receiver}#{@interceptor ?
        "... intercepted by #{@interceptor}!" : "."}"
    when :Shoot
      "#{@shooter} takes a shot... #{@blocker ?
        "#{@blocker} blocks the shot#{takes}!" : "and scores!" + score}" 
    else
      raise "Unknown message"
    end
  end

  private
  def of_period
    " of period #{@period}."
  end

  def score
    "\n#{@home} #{@home_score}, #{@away} #{@away_score}"
  end

  def takes
    @puck_taken ? " and takes the puck" : ""
  end
end

