# frozen_string_literal: true

require "rails_helper"
require "support/shared_context/login_with_admin_context"
require "support/shared_context/login_fails_context"

RSpec.describe(Admin::OrdersController, type: :controller) do
  include OrdersHelper

  let(:admin_user) { FactoryBot.create(:account, role: Account.roles[:admin], email: Faker::Internet.email, password: Faker::Internet.password) }
  let(:user) { FactoryBot.create(:account, role: Account.roles[:user], email: Faker::Internet.email, password: Faker::Internet.password) }
  let(:account) { FactoryBot.create(:account) }
  let(:order) { FactoryBot.create(:order, account_id: account.id) }

  def perform_action(method, action)
    case method
    when :get
      case action
      when :index
        get(:index)
      when :show
        get(:show, params: { id: order.id })
      end
    when :patch
      patch(:update, params: { id: order.id, status: :accept, comment: :accept })
    end
  end

  describe "GET #index" do
    let!(:orders) { create_list(:order, 4, account_id: user.id) }

    context "when login success and render success" do
      include_context "with a logged-in with admin", :get, :index

      it "render index" do
        expect(response).to(render_template("index"))
        expect(assigns(:orders)).to(all(be_a(Order)))
        expect(assigns(:orders).count).to(eq(2))
        expect(assigns(:pagy).count).to(eq(4))
        expect(response).to(have_http_status(:success))
      end
    end

    include_context "login fails", :get, :index
  end

  describe "GET #show" do
    let(:category) { create(:category) }
    let(:product) { create(:product, category_id: category.id) }
    let!(:order_histories) { create_list(:order_history, 6, order_id: order.id, product_id: product.id, current_price: 500, quantity: 1) }

    context "when login success" do
      include_context "with a logged-in with admin", :get, :show

      context "render show sucess" do
        it "render show success" do
          expect(response).to(render_template("show"))
          expect(assigns(:order_products)).to(all(be_a(OrderHistory)))
          expect(assigns(:order_products).count).to(eq(5))
          expect(total_price(assigns(:order))).to(eq(3000))
          expect(assigns(:pagy).count).to(eq(6))
          expect(response).to(have_http_status(:success))
        end
      end

      context "render show fails" do
        it "render show fails because order not found" do
          get :show, params: { id: -1 }

          expect(response).to(redirect_to("/404.html"))
        end
      end
    end

    include_context "login fails", :get, :show
  end

  describe "PATCH #update" do
    let!(:order_pending_status) { create(:order, account_id: account.id) }
    let!(:order_pending_approved) { create(:order, account_id: account.id, status: Order.statuses[:approved]) }

    before do
      allow(CustomerMailer).to(receive(:send_status_order_mail).and_return(double(deliver_now: true)))
    end

    context "when login success and render success" do
      include_context "with a logged-in with admin", :patch, :update

      context "when order.status = 'pending' is " do
        it "sets flash[:admin_success] with 'accept_order' message" do
          patch :update, params: { id: order_pending_status.id, status: :accept, comment: :accept }

          expect(assigns(:order).reload.status_approved?).to(eq(true))
          expect(flash[:admin_success]).to(eq(I18n.t("orders.accept_order", name: order_pending_status.receiver_name)))
          expect(response).to(redirect_to(admin_orders_path))
        end

        it "sets flash[:admin_success] with 'refuse_order' message" do
          patch :update, params: { id: order_pending_status.id, status: :other_status_difficult_accept, comment: :refuse }

          expect(assigns(:order).reload.status_reject?).to(eq(true))
          expect(flash[:admin_success]).to(eq(I18n.t("orders.refuse_order", name: order_pending_status.receiver_name)))
          expect(response).to(redirect_to(admin_orders_path))
        end
      end

      context "when order.status # 'pending' is " do
        it "sets flash[:admin_success] with 'accept_order' message" do
          patch :update, params: { id: order_pending_approved.id, status: :accept, comment: :accept }

          expect(assigns(:order).reload.status).to(eq(order_pending_approved.status))
          expect(flash[:admin_error]).to(eq(I18n.t("orders.status_fails")))
          expect(response).to(redirect_to(admin_orders_path))
        end
      end

      context "when update fails" do
        it "when update fails because was not found order" do
          patch :update, params: { id: -1, status: :reject }

          expect(response).to(redirect_to("/404.html"))
        end

        it "when update fails because was activeRecord:Rollback" do
          allow_any_instance_of(Order).to(receive(:update_status).and_return(false))

          patch :update, params: { id: order_pending_status.id, status: :accept, comment: :accept }

          expect(flash[:admin_error]).to(eq(I18n.t("orders.raise_error")))
          expect(response).to(redirect_to(admin_orders_path))
        end
      end
    end

    include_context "login fails", :patch, :update
  end
end
