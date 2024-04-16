# frozen_string_literal: true

class SendEmailOrderJob
  include Sidekiq::Job

  def perform(id, message, status)
    account = Account.find_by(id: id)
    CustomerMailer.send_status_order_mail(account, message, status).deliver
  end
end
