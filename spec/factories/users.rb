# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    username { Faker::Internet.user_name.gsub(/[^a-zA-Z0-9_]/, '_') }
    name { Faker::Name.name }

    confirmed_at { Time.current }

    trait :unconfirmed do
      confirmed_at nil
    end

    trait :with_picture do
      association :picture, factory: :user_picture
    end

    trait :with_cover_photo do
      association :cover_photo, factory: :user_cover_photo
    end

    trait :with_profile do
      association :profile, factory: :user_profile
    end

    trait :with_facebook_account do
      association :facebook_account, factory: :user_facebook_account
    end
  end
end
