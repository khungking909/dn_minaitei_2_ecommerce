# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :load_account, :authen_account, only: :create

  def new
    @account = Account.new
  end

  def create
    log_in(@account)
    remember(@account)
    flash[:success] = t("sessions.login_success")
    redirect_to(root_path)
  end

  def destroy
    log_out
    redirect_to(root_url)
  end

  private

  def load_account
    @account = Account.find_by(email: params.dig(:session, :email)&.downcase)
    return if @account

    flash.now[:error] = t("sessions.login_email_err")
    render(:new, status: :unprocessable_entity)
  end

  def authen_account
    return if @account.authenticate(params.dig(:session, :password))

    flash.now[:error] = t("sessions.login_password_err")
    render(:new, status: :unprocessable_entity)
  end
end
