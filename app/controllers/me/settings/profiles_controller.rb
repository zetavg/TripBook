# frozen_string_literal: true
class Me::Settings::ProfilesController < Me::SettingsController
  def show
    find_user
  end

  def update
    find_user
    @user.assign_attributes(user_params)

    if @user.save
      redirect_back fallback_location: me_settings_profile_path, flash: { success: '資料已更新' }
    else
      render :show
    end
  end

  private

  def find_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:belonging_picture_id, :name, :username, :gender, :birthdate)
  end
end
