# frozen_string_literal: true

class Order < ApplicationRecord
  ACCEPT = "accept".freeze
  REJECT_STATUS = "reject".freeze
  PENDING_STATUS = "pending".freeze
  APPROVED_STATUS = "approved".freeze
  CANCEL_STATUS = "cancel".freeze

  after_update :refund_quantity_products, if: :status_reject?

  validates :receiver_name, :receiver_address, :receiver_phone_number, presence: true

  enum status: { reject: 0,  cancel: 1, approved: 2, pending: 3 }, _default: :pending, _prefix: :status

  scope :order_by_status, -> { order(status: :desc) }
  scope :search_by_name, -> (search_term) { where("orders.receiver_name LIKE ?", "%#{search_term}%") if search_term.present? }
  scope :statistical_product, (lambda do
    select("DATE(orders.created_at) as order_date,
            SUM(order_histories.quantity) AS total_quantity,
            SUM(order_histories.quantity * order_histories.current_price) AS total_price"
          )
    .joins(:order_histories)
    .group("order_date")
    .where(orders: { status: Order.statuses[:approved] })
  end)

  def self.ransackable_attributes(_auth_object = nil)
    %w[receiver_name receiver_address created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[order_histories]
  end

  belongs_to :account
  has_many :order_histories, dependent: :destroy
  has_many :products, through: :order_histories

  delegate :count, to: :products, prefix: true
  delegate :name, to: :account, prefix: true

  accepts_nested_attributes_for :order_histories

  def update_status(status)
    if status
      status_approved!
    else
      status_reject!
    end
  end

  def update_message_and_send_mail(message, status)
    CustomerMailer.send_status_order_mail(account, message, status).deliver_now if update_columns(message: message)
  end

  def refund_quantity_products
    order_histories.each do |element|
      element.product_refund_quantity(element.quantity)
    end
  end
end
