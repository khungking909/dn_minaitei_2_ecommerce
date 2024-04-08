# frozen_string_literal: true

module SessionsHelper
  def check_admin
    current_account.admin?
  end
end
