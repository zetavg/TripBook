# frozen_string_literal: true
FactoryGirl.define do
  factory :book_info_cover_image, class: BookInfo::CoverImage do
    transient do
      size [600, 840]
      background_color { Faker::Color.hex_color }
      color { Faker::Color.hex_color }
    end

    remote_image_url do
      "http://placehold.it/#{size[0]}x#{size[1]}/#{color.delete('#')}/#{background_color.delete('#')}"
    end
  end
end
