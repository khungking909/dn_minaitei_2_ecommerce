# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :parse_cart_data, only: :create
  before_action :find_products, only: :create
  before_action :load_order, only: :cancel

  def index
    @pagy, @orders = pagy(current_account.orders.order(created_at: :desc), items: Settings.PAGE_10)
  end

  def show; end

  def create
    @order = Order.new(order_params)

    ActiveRecord::Base.transaction do
      @order.save!
      update_product_quantities!(-Settings.DIGIT_1)
    end

    cookies.delete(:cart)
    flash[:success] = t("orders.create.success")
    redirect_to(cart_path)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t("orders.create.fail")
    redirect_back(fallback_location: cart_path)
  end

  def cancel
    ActiveRecord::Base.transaction do
      @order.update!(status: :cancel)
      update_product_quantities!(Settings.DIGIT_1)
    end

    flash[:success] = t("orders.cancel.success")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t("orders.cancel.fail")
  ensure
    redirect_to(orders_path)
  end

  private

  def update_product_quantities!(sign)
    @order.order_histories.each do |order_history|
      product = Product.find_by(id: order_history.product_id)
      product.update!(quantity: product.quantity + (order_history.quantity * sign))
    end
  end

  def parse_cart_data
    cart_data = JSON.parse(cookies[:cart])
    @order_history_params = []

    cart_data.each do |product_id, item|
      quantity = item[Product::QUANTITY]
      @order_history_params << { product_id: product_id, quantity: quantity }
    end
  end

  def find_products
    @order_history_params.each do |order_history|
      product = Product.find_by(id: order_history[:product_id])
      order_history[:current_price] = product&.price

      next if product

      flash[:error] = t("products.empty")
      @cart.delete(order_history[:product_id])
      cookies.permanent[:cart] = @cart.to_json
      redirect_to(cart_path)
      break
    end
  end

  def load_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:error] = t("orders.not_found")
    redirect_to(orders_path)
  end

  def order_params
    params.permit(:receiver_name, :receiver_address, :receiver_phone_number).merge(
      account_id: current_account.id,
      order_histories_attributes: @order_history_params
    )
  end
end
