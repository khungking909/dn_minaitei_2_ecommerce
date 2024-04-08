# frozen_string_literal: true

class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      flash[:success] = t("accounts.register_success")
      redirect_to(root_path)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :email, :address, :phone_number, :password, :password_confirmation)
  end

  def after_inactive_sign_up_path_for(resource)
    new_session_path(resource)
  end
end
