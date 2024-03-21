# frozen_string_literal: true

class Admin::OrdersController < Admin::AdminController
  def index
    @pagy, @orders = pagy(Order.order_by_status, items: Settings.DIGIT_2)
  end
end
