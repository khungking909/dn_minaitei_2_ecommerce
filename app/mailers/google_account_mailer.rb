# frozen_string_literal: true

class GoogleAccountMailer < ApplicationMailer
  def send_current_password(current_password, mail)
    @current_password = current_password

    mail(to: mail, subject: t("accounts.mailer.subject_oauth"))
  end
end
