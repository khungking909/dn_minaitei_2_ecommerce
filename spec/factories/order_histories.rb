# frozen_string_literal: true

FactoryBot.define do
  factory :order_history do
    order_id { 1 }
    product_id { 1 }
    quantity { Faker::Number.between(from: 1, to: 100) }
    current_price { Faker::Number.between(from: 1, to: 100) }
  end
end
