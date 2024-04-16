# frozen_string_literal: true

class SendEmailAccountJob
  include Sidekiq::Job

  def perform(id, token, email_type)
    record = Account.find_by(id: id)
    case email_type
    when Account::CONFIRMATION
      AccountMailer.confirmation_instructions(record, token).deliver
    when Account::RESET_PASSWORD
      AccountMailer.reset_password_instructions(record, token).deliver
    end
  end
end
