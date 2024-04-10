# frozen_string_literal: true

class OmniauthesController < Devise::OmniauthCallbacksController
  def google_oauth2
    @account = Account.from_omniauth(request.env["omniauth.auth"])
    if @account.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "Google")
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
    end
    sign_in_and_redirect(@account, event: :authentication)
  end
end
