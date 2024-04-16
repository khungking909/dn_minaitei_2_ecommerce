# frozen_string_literal: true

class SendEmailGoogleOauthJob
  include Sidekiq::Job

  def perform(email, password, _email_type)
    GoogleAccountMailer.send_current_password(password, email).deliver
  end
end
