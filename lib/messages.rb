# frozen_string_literal: true

class Messages
  def initialize(event, fields, data)
    @event = event
    fields.zip(data) do |(f, d)|
      instance_variable_set("@#{f}", d)
    end
  end

  private_class_method(:new)

  class << self
    [
      %i[StartOfGame title],
      %i[EndOfGame winning_team],
      %i[StartOfPeriod period],
      %i[EndOfPeriod period home away home_score away_score],
      %i[FaceOff winning_player],
      %i[Hit puck_holder defender puck_taken],
      %i[Pass sender receiver interceptor],
      %i[Shoot shooter blocker puck_taken home away home_score away_score]
    ].each do |event, *fields|
      define_method event do |*data|
        new(event, fields, data)
      end
    end
  end

  def to_s
    case @event
    when :StartOfGame
      "#{@title}\nHocky!"
    when :EndOfGame
      "Game over.\n#{@winning_team} wins!"
    when :StartOfPeriod
      "Start#{of_period}"
    when :EndOfPeriod
      "End#{of_period}#{score}"
    when :FaceOff
      "#{@winning_player} wins the faceoff!"
    when :Hit
      "#{@defender} hits #{@puck_holder.to_s + takes}!"
    when :Pass
      "#{@sender} passes to #{@receiver}" +
        (@interceptor ? "... intercepted by #{@interceptor}!" : '.')
    when :Shoot
      "#{@shooter} takes a shot... " +
        (@blocker ? "#{@blocker} blocks the shot#{takes}!" : "and scores!#{score}")
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
    @puck_taken ? ' and takes the puck' : ''
  end
end
