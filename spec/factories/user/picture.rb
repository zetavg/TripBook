# frozen_string_literal: true
FactoryGirl.define do
  factory :user_picture, class: User::Picture do
    transient do
      size [512, 512]
      background_color { Faker::Color.hex_color }
      color { Faker::Color.hex_color }
    end

    user
    remote_image_url do
      "http://placehold.it/#{size[0]}x#{size[1]}/#{color.delete('#')}/#{background_color.delete('#')}"
    end
  end
end
