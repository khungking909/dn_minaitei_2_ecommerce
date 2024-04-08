# frozen_string_literal: true

class AccountsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :address, :phone_number) }
  end

  def after_inactive_sign_up_path_for(resource)
    new_session_path(resource)
  end
end
