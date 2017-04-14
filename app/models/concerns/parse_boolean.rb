# frozen_string_literal: true
module ParseBoolean
  extend ActiveSupport::Concern

  FALSE_VALUES = [nil, false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF', ''].freeze

  def parse_boolean(value)
    !FALSE_VALUES.include?(value)
  end
end
