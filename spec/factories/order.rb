# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    account_id { 1 }
    receiver_name { Faker::Name.name }
    receiver_address { Faker::Address.full_address }
    receiver_phone_number { Faker::PhoneNumber.phone_number }
    status { rand(0..3) }
  end
end
