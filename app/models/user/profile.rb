# frozen_string_literal: true
class User
  class Profile < ApplicationRecord
    include Trackable

    belongs_to :user, optional: true

    enum gender: {
      male:   1,
      female: 2,
      other:  3
    }

    def birthdate
      return unless birthday_year.present? && birthday_month.present? && birthday_day.present?
      Date.new(birthday_year.to_i, birthday_month.to_i, birthday_day.to_i)
    end

    def birthdate=(date)
      d = case date
          when Hash
            Date.new(*date.map { |_, v| v })
          else
            Date.parse(date.to_s)
          end

      self.birthday_year = d.year
      self.birthday_month = d.month
      self.birthday_day = d.day
    rescue ArgumentError
      false
    end
  end
end
