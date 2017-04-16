# frozen_string_literal: true
class Me::SettingsController < ApplicationController
  layout 'me/settings'

  def show
    redirect_to me_settings_profile_path
  end
end
