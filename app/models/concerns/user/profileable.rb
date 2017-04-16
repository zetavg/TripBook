# frozen_string_literal: true
class User
  module Profileable
    extend ActiveSupport::Concern

    included do
      has_one :profile, autosave: true
      accepts_nested_attributes_for :profile
      delegate :gender,  :birthdate,  :birthday_year,  :birthday_month,  :birthday_day,
               :gender=, :birthdate=, :birthday_year=, :birthday_month=, :birthday_day=,
               to: :profile, prefix: false
    end

    def profile
      super || build_profile
    end
  end
end
