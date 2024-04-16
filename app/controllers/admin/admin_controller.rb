# frozen_string_literal: true

class Admin::AdminController < ApplicationController
  include OrdersHelper

  before_action :authenticate_account!
end
