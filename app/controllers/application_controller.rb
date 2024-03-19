# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("sessions.mess_pls_login")
    redirect_to(login_path)
  end
end
