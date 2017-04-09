# frozen_string_literal: true
json.id user.id
json.username user.username
json.name user.name
if user.picture.present?
  json.picture user.picture, partial: 'api/user_pictures/user_picture',
                             as: :user_picture
end
