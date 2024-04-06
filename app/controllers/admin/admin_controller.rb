# frozen_string_literal: true

class Admin::AdminController < ApplicationController
  include OrdersHelper

  before_action :logged_in_user, :author_admin

  def author_admin
    return if current_account.admin?

    redirect_to("/403.html")
  end
end
