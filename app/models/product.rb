# frozen_string_literal: true

class Product < ApplicationRecord
  QUANTITY = "quantity".freeze

  has_many :comments, dependent: :destroy
  has_many :order_histories, dependent: :destroy
  belongs_to :category
  has_many :orders, through: :order_histories
  has_many :accounts, through: :comments

  has_one_attached :image do |attachable|
    attachable.variant(:display, resize_to_limit: Settings.SIZE_400x400)
  end

  scope :get_all_by_name_sort, -> { order(:name) }
  scope :search_by_name, -> (search_term) { where("name LIKE ?", "%#{search_term}%") if search_term.present? }
  scope :sort_by_category, -> (category_id) { where(category_id: category_id) if category_id.present? }
  scope :sort_by_range_price, lambda { |min_price, max_price|
                                where("price >= ? AND price <= ?", min_price, max_price) if min_price.present? && max_price.present?
                              }
  scope :newest, -> { order(created_at: :desc) }
  scope :product_outstanding, (lambda do
    select("products.*, SUM(order_histories.quantity) AS total_quantity")
    .joins(:order_histories)
    .group("products.id")
    .order("total_quantity DESC")
    .joins("INNER JOIN orders ON orders.id = order_histories.order_id")
    .where(orders: { status: Order.statuses[:approved] })
    .limit(Settings.DIGIT_10)
  end)

  validates :name, presence: true, length: { maximum: Settings.DIGIT_255 }
  validates :price, presence: true
  validates :description, presence: true, length: { maximum: Settings.DIGIT_1000 }

  def self.parse_price_range(price_range)
    return { min_price: nil, max_price: nil } if price_range.blank?

    min_price, max_price = price_range.split("-").map do |price|
      Integer(price.strip, 10) if price.strip.match?(/^\d+$/)
    end

    { min_price: min_price, max_price: max_price }
  end

  delegate :name, to: :category, prefix: true

  def refund_quantity(quantity)
    return if update(quantity: self.quantity + quantity)

    raise(ActiveRecord::Rollback)
  end
end
