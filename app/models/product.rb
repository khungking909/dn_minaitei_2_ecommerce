# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :order_histories, dependent: :destroy
  belongs_to :category
  has_many :orders, through: :order_histories
  has_many :accounts, through: :comments

  scope :get_all_by_name_sort, -> { order("name") }
end
