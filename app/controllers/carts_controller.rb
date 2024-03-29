# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :load_cart
  before_action :load_product, only: %i[create destroy]
  before_action :set_cart, only: :create
  before_action :load_cart_product, only: :show

  def show; end

  def create
    product_id = params[:product_id].to_s
    if @cart[product_id].key?(:quantity)
      cookies.permanent[:cart] = @cart.to_json
      flash[:success] = t("cart.added", product_name: @product.name)
    else
      flash[:error] = t("cart.run_out", product_name: @product.name)
    end
    redirect_to(cart_path)
  end

  def destroy
    product_id = @product.id.to_s
    if @cart.key?(product_id)
      @cart.delete(product_id)
      cookies.permanent[:cart] = @cart.to_json
      flash[:success] = t("cart.remove_product_success", product_name: @product.name)
    else
      flash[:error] = t("cart.product_not_in_cart")
    end
    redirect_to(cart_path)
  end

  private

  def set_cart
    @cart ||= {}
    product_id = params[:product_id].to_s
    current_quantity = @cart.dig(product_id, "quantity") || 0
    current_quantity += 1
    @cart[product_id] = { product_id: product_id, quantity: current_quantity }
  end

  def load_cart
    @cart = JSON.parse(cookies[:cart])
  rescue StandardError
    @cart = {}
  end

  def load_product
    @product = Product.find_by(id: params[:product_id])
    return if @product

    flash[:error] = t("cart.product_not_found")
    redirect_to(root_path)
  end

  def load_cart_product
    @cart_products = {}
    @cart.each_key do |product_id|
      product = Product.find_by(id: product_id)
      product ? @cart_products[product_id] = product : @cart.delete(product_id)
    end
    cookies.permanent[:cart] = @cart.to_json
  end
end
