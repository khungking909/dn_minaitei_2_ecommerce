# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    price { Faker::Number.decimal(l_digits: 2) }
    quantity { Faker::Number.between(from: 1, to: 100) }
    category { association :category }
    description { Faker::Lorem.paragraph }
  end
end
