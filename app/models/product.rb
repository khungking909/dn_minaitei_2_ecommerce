# frozen_string_literal: true

class Product < ApplicationRecord
  QUANTITY = "quantity".freeze

  has_many :comments, dependent: :destroy
  has_many :order_histories, dependent: :restrict_with_error
  belongs_to :category
  has_many :orders, through: :order_histories
  has_many :accounts, through: :comments

  has_one_attached :image do |attachable|
    attachable.variant(:display, resize_to_limit: Settings.SIZE_224x224)
  end

  scope :price_sort, -> { where(is_deleted: false).order(price: :desc) }
  scope :product_outstanding, (lambda do
                                 select("products.*, SUM(order_histories.quantity) AS total_quantity")
                                 .joins(:order_histories)
                                 .group("products.id")
                                 .order("total_quantity DESC")
                                 .joins("INNER JOIN orders ON orders.id = order_histories.order_id")
                                 .where(orders: { status: Order.statuses[:approved] })
                                 .where(is_deleted: false)
                                 .limit(Settings.DIGIT_10)
                               end)

  validates :name, presence: true, length: { maximum: Settings.DIGIT_255 }
  validates :price, presence: true, numericality: true
  validates :description, presence: true, length: { maximum: Settings.DIGIT_1000 }
  validates :quantity, presence: true, numericality: true, length: { maximum: Settings.DIGIT_1000 }

  ransacker :created_at_year do
    Arel::Nodes::SqlLiteral.new("year(products.created_at)")
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at_year description name price quantity created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end

  delegate :name, to: :category, prefix: true

  def refund_quantity(quantity)
    return if update(quantity: self.quantity + quantity)

    raise(ActiveRecord::Rollback)
  end

  def delete_soft
    return false if orders.exists?(status: Order.statuses[:pending])

    update_columns(is_deleted: true)
  end
end
