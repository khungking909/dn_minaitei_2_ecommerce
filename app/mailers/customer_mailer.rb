# frozen_string_literal: true

class CustomerMailer < ApplicationMailer
  def send_status_order_mail(account, message, status)
    @message = message
    subject = if status
                t("orders.mail.accepted")
              else
                t("orders.mail.refused")
              end

    mail(to: account.email, subject: subject)
  end
end
