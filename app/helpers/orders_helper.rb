# frozen_string_literal: true

module OrdersHelper
  def total_price(order)
    order.order_histories.reduce(0) { |sum, value| sum + value.current_price * value.quantity }
  end

  def calculate_status?(string)
    string == Order::ACCEPT
  end
end
