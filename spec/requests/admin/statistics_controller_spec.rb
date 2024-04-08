# frozen_string_literal: true

require "rails_helper"
require "support/shared_context/login_with_admin_context"
require "support/shared_context/login_fails_context"

RSpec.describe(Admin::StatisticsController, type: :controller) do
  let(:category) { create(:category) }
  let(:product) { create(:product, category_id: category.id) }
  let(:account) { FactoryBot.create(:account) }
  let!(:order_month_1) { create(:order, account_id: account.id, created_at: "2024-1-12", status: Order.statuses[:approved]) }
  let!(:order_month_2) { create(:order, account_id: account.id, created_at: "2024-2-12", status: Order.statuses[:approved]) }
  let!(:order_histories_month_1) do
    create_list(:order_history,
                10,
                order_id: order_month_1.id,
                product_id: product.id,
                quantity: 1,
                current_price: 500
               )
  end
  let!(:order_histories_month_2) do
    create_list(:order_history,
                5,
                order_id: order_month_2.id,
                product_id: product.id,
                quantity: 1,
                current_price: 200
               )
  end

  def perform_action(_method, action)
    case action
    when :monthly_statistics
      get(:monthly_statistics)
    when :monthly_statistics_detail
      get(:monthly_statistics_detail, params: { month: 1, year: 2024 })
    end
  end

  describe "GET #monthly_statistics" do
    context "when login success and render success" do
      include_context "with a logged-in with admin", :get, :monthly_statistics

      it "render index" do
        expect(response).to(render_template("monthly_statistics"))
        expect(assigns(:statistics)).to(be_a(ActiveRecord::Relation))
        expect(assigns(:statistics)).to(all(be_a(Order)))
        expect(assigns(:statistics).to_a.count).to(eq(2))
        expect(assigns(:statistics).to_a.first.total_price).to(eq(5000))
        expect(assigns(:statistics).last.total_price).to(eq(1000))
        expect(response).to(have_http_status(:success))
      end
    end

    include_context "login fails", :get, :monthly_statistics
  end

  describe "GET #monthly_statistics_detail" do
    context "when login success and render success" do
      include_context "with a logged-in with admin", :get, :monthly_statistics_detail

      it "render index" do
        expect(response).to(render_template("monthly_statistics_detail"))
        expect(assigns(:statistics_detail)).to(be_a(ActiveRecord::Relation))
        expect(assigns(:statistics_detail).to_a.count).to(eq(1))
        expect(assigns(:statistics_detail).to_a.first.product_total_quantity).to(eq(10))
        expect(assigns(:statistics_detail_sum)).to(eq(5000))
        expect(assigns(:pagy).count).to(eq(1))
      end
    end

    include_context "login fails", :get, :monthly_statistics_detail
  end
end
