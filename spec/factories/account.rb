# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { Faker::Internet.name }
    email { Faker::Internet.email }
    address { Faker::Address.full_address }
    password { Faker::Internet.password }
    password_confirmation { password }
  end
end
