# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    username { Faker::Internet.user_name }
    name { Faker::Name.name }

    trait :confirmed do
      after(:create) do |_, instance|
        instance.confirm
      end
    end
  end
end
