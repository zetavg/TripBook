# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end

  private

  def extract_locale_from_accept_language_header
    case request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-zA-Z\-]{2,5}/).first
    when 'en'
      'en'
    when 'zh-TW'
      'zh-TW'
    else
      'en'
  end

  def info_for_paper_trail
    if is_a?(ActiveAdmin::BaseController)
      { operator_type: current_admin&.class&.name, operator_id: current_admin&.id }
    else
      { operator_type: current_user&.class&.name, operator_id: current_user&.id }
    end
  end
end
