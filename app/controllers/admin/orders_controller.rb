# frozen_string_literal: true

class Admin::OrdersController < Admin::AdminController
  before_action :load_order, only: %i(update show)
  before_action :check_status, only: :update

  def index
    @pagy, @orders = pagy(Order.order_by_status, items: Settings.DIGIT_2)
  end

  def show
    @pagy, @order_products = pagy(@order.order_histories, items: Settings.DIGIT_5)
  end

  def update
    status = calculate_status?(params[:status])
    if @order.update_status(status)
      respond_to do |format|
        format.html do
          flash[:admin_success] = if status
                                    t("orders.accept_order", name: @order.receiver_name)
                                  else
                                    t("orders.refuse_order", name: @order.receiver_name)
                                  end
          redirect_to(admin_orders_path)
        end
        format.turbo_stream
      end
    else
      flash[:admin_error] = t("orders.raise_error")
      redirect_to(admin_orders_path)
    end
  end

  private

  def load_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:admin_error] = t("orders.not_found")
    redirect_to(admin_orders_path)
  end

  def check_status
    return if @order.status_pending?

    flash[:admin_error] = t("orders.status_fails")
    redirect_to(admin_orders_path)
  end
end
