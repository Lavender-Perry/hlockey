# frozen_string_literal: true

require('yaml')

module Hlockey
  def Hlockey.load_data(category)
    # If this is only used on data included with the gem, it should be safe
    YAML.unsafe_load_file(File.expand_path("data/#{category}.yaml", __dir__))
  end
end
