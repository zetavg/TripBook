# frozen_string_literal: true
FactoryGirl.define do
  factory :user_profile, class: User::Profile do
    transient do
      birthday { Faker::Date.between(32.years.ago, 16.years.ago) }
    end

    user
    gender { %w(male female).sample }
    birthday_year { birthday.year }
    birthday_month { birthday.month }
    birthday_day { birthday.day }
  end
end
