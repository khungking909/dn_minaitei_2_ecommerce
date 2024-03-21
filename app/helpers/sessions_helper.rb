# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable

module SessionsHelper
  def log_in(account)
    session[:account_id] = account.id
  end

  def current_account
    if (account_id = session[:account_id])
      @current_account ||= Account.find_by(id: account_id)
    elsif (account_id = cookies.signed[:account_id])
      account = Account.find_by(id: account_id)
      if account&.authenticated?(:remember, cookies[:remember_token])
        log_in(account)
        @current_account = account
      end
    end
  end

  def remember(account)
    account.remember
    cookies.permanent.signed[:account_id] = account.id
    cookies.permanent[:remember_token] = account.remember_token
  end

  def forget(account)
    account.forget
    cookies.delete(:account_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_account)
    reset_session
    @current_account = nil
  end

  def logged_in?
    current_account.present?
  end

  def check_admin
    current_account.admin?
  end
end

# rubocop:enable Rails/HelperInstanceVariable
