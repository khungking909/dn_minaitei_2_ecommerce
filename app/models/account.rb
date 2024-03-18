# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :products, through: :comments
end
