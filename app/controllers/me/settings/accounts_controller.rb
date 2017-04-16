# frozen_string_literal: true
class Me::Settings::AccountsController < Me::SettingsController
  def show
    find_user
  end

  def update
    find_user
    prev_unconfirmed_email = @user.unconfirmed_email

    if update_user
      if @user.pending_reconfirmation? && @user.unconfirmed_email != prev_unconfirmed_email
        flash[:warning] = "系統已發送一封確認郵件至 #{@user.unconfirmed_email}，請前往確認您的新電子郵件地址"
      end

      if user_params[:password]
        flash[:info] = '您的密碼已更新'
      end

      bypass_sign_in @user
      redirect_back fallback_location: me_settings_account_path
    else
      @user.clean_up_passwords
      render :show
    end
  end

  private

  def find_user
    @user = current_user
  end

  def update_user
    if user_params[:current_password]
      @user.update_with_password(user_params)
    else
      @user.update_attributes(user_params)
    end
  end

  def user_params
    return @user_params if @user_params.present?

    @user_params = params.require(:user).permit(
      :email,
      :current_password,
      :password,
      :password_confirmation
    )

    if @user_params[:current_password].present?
      @user_params[:password] = '-' if @user_params[:password].blank?
    else
      @user_params = @user_params.except(:current_password, :password, :password_confirmation)
    end

    @user_params
  end
end
