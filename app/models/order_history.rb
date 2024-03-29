# frozen_string_literal: true

class OrderHistory < ApplicationRecord
  belongs_to :order
  belongs_to :product

  delegate :name, :category_name, :refund_quantity, to: :product, prefix: true
  delegate :status, to: :order, prefix: true
end
