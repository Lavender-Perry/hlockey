# frozen_string_literal: true

module Hlockey
  class Team
    private_class_method(:new)

    attr_accessor(:wins, :losses)
    attr_reader(:to_s, :emoji, :roster)

    def name_with_emoji
      "#{@emoji} #{@to_s}"
    end
  end
end
