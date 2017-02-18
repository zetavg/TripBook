# frozen_string_literal: true
FactoryGirl.define do
  factory :user_facebook_account, class: User::FacebookAccount do
    user
    facebook_id { Faker::Number.number(16) }
    email { Faker::Internet.safe_email }
    name { Faker::Name.name }
    access_token { SecureRandom.hex(64) }
    access_token_expires_at { 1.month.from_now.to_i }

    trait :with_picture do
      picture_url { "http://placehold.it/512x512/#{Faker::Color.hex_color[1..6]}/#{Faker::Color.hex_color[1..6]}" }
    end

    trait :with_cover_photo do
      cover_photo_url { "http://placehold.it/1024x512/#{Faker::Color.hex_color[1..6]}/#{Faker::Color.hex_color[1..6]}" }
    end
  end
end
