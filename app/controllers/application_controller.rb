# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Devise::Controllers::Helpers

  rescue_from CanCan::AccessDenied, with: :handle_error_access_denied!
  rescue_from ActiveRecord::RecordNotFound, with: :handle_error_active_record_notfound!

  before_action :set_locale
  before_action :load_ability
  before_action :authorize_action

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def load_ability
    @current_ability ||= Ability.new(current_account)
  end

  def handle_error_access_denied!
    redirect_to("/403.html")
  end

  def handle_error_active_record_notfound!(_exception)
    redirect_to("/404.html")
  end

  def authorize_action; end
end
