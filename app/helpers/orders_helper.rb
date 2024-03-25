# frozen_string_literal: true

module OrdersHelper
  def total_price(order)
    order.order_histories.reduce(0) { |sum, value| sum + value.current_price * value.quantity }
  end

  def calculate_status?(string)
    string == Order::ACCEPT
  end

  def order_status_button(status)
    case status
    when Order::PENDING_STATUS
      content_tag(:button, t("orders.status.pending"), class: "btn btn-outline-primary btn-sm pe-none")
    when Order::REJECT_STATUS
      content_tag(:button, t("orders.status.reject"), class: "btn btn-outline-danger btn-sm pe-none")
    when Order::APPROVED_STATUS
      content_tag(:button, t("orders.status.approved"), class: "btn btn-outline-success btn-sm pe-none")
    when Order::CANCEL_STATUS
      content_tag(:button, t("orders.status.cancel"), class: "btn btn-outline-secondary btn-sm pe-none")
    end
  end

  def check_status(order)
    if order.status == Order::REJECT_STATUS || order.status == Order::CANCEL_STATUS
      link_to(t("orders.actions.reason"), "#", class: "btn btn-info btn-sm")
    elsif order.status == Order::PENDING_STATUS
      link_to(t("orders.actions.cancel"), cancel_order_path(order), method: :patch, data: { confirm: t("orders.actions.confirm") },
                                                                    class: "btn btn-danger btn-sm"
      )
    end
  end

  def approved_status(order, order_history)
    return unless order.status == Order::APPROVED_STATUS

    link_to(t("orders.actions.review"), new_product_comment_path(product_id: order_history.product_id), class: "btn btn-success btn-sm")
  end
end
