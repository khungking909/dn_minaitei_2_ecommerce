# frozen_string_literal: true

class Admin::AdminController < ApplicationController
  include OrdersHelper

  before_action :authenticate_account!, :authorize_action

  private

  def authorize_action
    authorize!(:access_denied_user, :controller)
  end
end
