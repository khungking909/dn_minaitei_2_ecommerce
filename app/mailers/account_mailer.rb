# frozen_string_literal: true

class AccountMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts = {})
    mail = super

    mail.subject = t("devise.mailer.confirmation_instructions.subject")
  end

  def reset_password_instructions(record, token, opts = {})
    mail = super

    mail.subject = t("devise.mailer.reset_password_instructions.subject")
  end
end
