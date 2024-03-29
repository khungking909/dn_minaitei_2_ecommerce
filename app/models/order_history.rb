# frozen_string_literal: true

class OrderHistory < ApplicationRecord
  belongs_to :order
  belongs_to :product

  delegate :name, :category_name, :refund_quantity, to: :product, prefix: true
  delegate :status, to: :order, prefix: true

  scope :statistical_detail, (lambda do |year, month|
    select("p.name as name_product,
            SUM(order_histories.quantity) AS product_total_quantity,
            SUM(order_histories.quantity * order_histories.current_price) AS product_total_price"
          )
    .joins(:order)
    .group("product_id")
    .joins("INNER JOIN products p ON p.id = product_id")
    .where(order: { status: Order.statuses[:approved] })
    .where("YEAR(order.created_at) = ? AND MONTH(order.created_at) = ?", year, month)
  end)
end
