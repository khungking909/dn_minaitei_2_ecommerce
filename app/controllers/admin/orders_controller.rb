# frozen_string_literal: true

class Admin::OrdersController < Admin::AdminController
  load_resource only: %i(show update)
  authorize_resource only: %i(index show update)
  before_action :check_status, only: :update

  def index
    @pagy, @orders = pagy(Order.ransack(params[:search]).result, items: Settings.DIGIT_2)
  end

  def show
    @pagy, @order_products = pagy(@order.order_histories, items: Settings.DIGIT_5)
  end

  def update
    status = calculate_status?(params[:status])
    if @order.update_status(status)
      @order.update_message_and_send_mail(params[:comment], status)
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

  def check_status
    return if @order.status_pending?

    flash[:admin_error] = t("orders.status_fails")
    redirect_to(admin_orders_path)
  end
end
