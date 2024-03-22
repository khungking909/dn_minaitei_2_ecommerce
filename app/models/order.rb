# frozen_string_literal: true

class Order < ApplicationRecord
  enum status: { reject: 0, approved: 1, pending: 2 }, _default: :pending, _prefix: :status

  scope :order_by_status, -> { order(status: :desc) }

  belongs_to :account
  has_many :order_histories, dependent: :destroy
  has_many :products, through: :order_histories
end
