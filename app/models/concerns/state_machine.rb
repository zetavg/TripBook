# frozen_string_literal: true
module StateMachine
  extend ActiveSupport::Concern

  included do
    include AASM
  end

  class_methods do
    def state_machine(*args, &block)
      aasm(*args, &block)
    end
  end

  # def aasm_event_failed(event_name, new_state)
  #   if errors.any?
  #     raise ActiveRecord::RecordInvalid.new(self)
  #   end
  # end
end
