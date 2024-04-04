# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    price { Faker::Number.decimal(l_digits: 2) }
    quantity { Faker::Number.between(from: 1, to: 100) }
    category { association :category }
    description { Faker::Lorem.paragraph }
    image { Rack::Test::UploadedFile.new(File.open(Rails.root.join("spec/files/image_test.jpg").to_s)) }
  end
end
