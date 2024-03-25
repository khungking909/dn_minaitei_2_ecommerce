# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { %w(Apple Samsung Xiaomi Oppo Huawei Vivo).sample }
  end
end
