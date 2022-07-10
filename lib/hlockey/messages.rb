# frozen_string_literal: true

module Hlockey
  class Messages
    private_class_method(:new)

    def initialize(event, fields, data)
      @event = event
      fields.zip(data) do |(f, d)|
        instance_variable_set("@#{f}", d)
      end
    end

    class << self
      [
        %i[StartOfGame title],
        %i[EndOfGame winning_team],
        %i[StartOfPeriod period],
        %i[EndOfPeriod period home away home_score away_score],
        %i[FaceOff winning_player new_puck_team],
        %i[Hit puck_holder defender puck_taken new_puck_team],
        %i[Pass sender receiver interceptor new_puck_team],
        %i[ShootScore shooter home away home_score away_score],
        %i[ShootBlock shooter blocker puck_taken new_puck_team]
      ].each do |event, *fields|
        define_method(event) do |*data|
          new(event, fields, data)
        end
      end
    end

    def to_s
      case @event
      when :StartOfGame
        "#{@title}\nHocky!"
      when :EndOfGame
        "Game over.\n#{@winning_team} win!"
      when :StartOfPeriod
        "Start#{of_period}"
      when :EndOfPeriod
        "End#{of_period}#{score}"
      when :FaceOff
        "#{@winning_player} wins the faceoff!#{possession_change}"
      when :Hit
        "#{@defender} hits #{@puck_holder}#{takes}"
      when :Pass
        "#{@sender} passes to #{@receiver}." +
          "#{"..\nIntercepted by #{@interceptor}!#{possession_change}" if @interceptor}"
      when :ShootScore
        "#{shot} and scores!#{score}"
      when :ShootBlock
        "#{shot}...\n#{@blocker} blocks the shot#{takes}"
      end
    end

    private

    def of_period
      " of period #{@period}."
    end

    def score
      "\n#{@home} #{@home_score}, #{@away} #{@away_score}"
    end

    def shot
      "#{@shooter} takes a shot"
    end

    def takes
      @puck_taken ? " and takes the puck!#{possession_change}" : '!'
    end

    def possession_change
      "\n#{@new_puck_team} have possession."
    end
  end
end
