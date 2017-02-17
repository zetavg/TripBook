# frozen_string_literal: true
module Facebook
  APP_ID = Config.facebook.app_id
  APP_SECRET = Config.facebook.app_secret
  SCOPES = [:email, :public_profile, :user_friends].freeze
  USER_INFO_FIELDS = [:id, :email, :name, :gender, :link, :'picture.height(512).width(512)', :cover].freeze
  SCOPES_STRING = SCOPES.join(',')
  USER_INFO_FIELDS_STRING = USER_INFO_FIELDS.join(',')
end
