# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :account
  has_many :order_histories, dependent: :destroy
  has_many :products, through: :order_histories
end
