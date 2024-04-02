# frozen_string_literal: true

require "rails_helper"
require "support/shared_context/login_with_admin_context"
require "support/shared_context/login_fails_context"

RSpec.describe(Admin::ProductsController, type: :controller) do
  include SessionsHelper

  let(:category) { create(:category) }
  let(:product) { create(:product, category_id: category.id) }
  let(:params) do
    {
      product: {
        name: Faker::Name.name,
        price: rand(5..100),
        quantity: rand(1..20),
        category_id: category.id,
        description: Faker::Lorem.paragraph
      }
    }
  end

  def perform_action(method, action)
    case method
    when :get
      case action
      when :index
        get(:index)
      when :edit
        get(:edit, params: { id: product.id })
      when :new
        get(:new)
      end
    when :post
      post(:create, params: params)
    when :delete
      delete(:destroy, params: { id: product.id })
    when :patch
      patch(:update, params: { id: product.id, product: params })
    end
  end
  describe "GET #index" do
    let!(:products) { create_list(:product, 6, category_id: category.id) }

    context "when login success and render success" do
      include_context "with a logged-in with admin", :get, :index

      it "render index" do
        expect(response).to(render_template("index"))
        expect(assigns(:products)).to(all(be_a(Product)))
        expect(assigns(:products).count).to(eq(5))
        expect(assigns(:pagy).count).to(eq(Product.count))
        expect(response).to(have_http_status(:success))
      end
    end

    include_context "login fails", :get, :index
  end

  describe "GET #edit" do
    context "when login success" do
      include_context "with a logged-in with admin", :get, :edit

      context "render edit sucess" do
        it "render edit success" do
          expect(response).to(render_template("edit"))
          expect(assigns(:product)).to(be_a(Product))
          expect(response).to(have_http_status(:success))
        end
      end

      context "render edit fails" do
        it "render edit fails" do
          get :edit, params: { id: 9_999_999_999_999_999 }

          expect(flash[:admin_error]).to(eq(I18n.t("admin.products.load.not_found")))
          expect(response).to(have_http_status(:found))
          expect(response).to(redirect_to(admin_orders_path))
        end
      end
    end

    include_context "login fails", :get, :edit
  end

  describe "GET #new" do
    context "when login success " do
      include_context "with a logged-in with admin", :get, :new

      it "render new" do
        expect(response).to(render_template("new"))
        expect(assigns(:product)).to(be_a_new(Product))
        expect(response).to(have_http_status(:success))
      end
    end

    include_context "login fails", :get, :new
  end

  describe "PATCH #update" do
    context "when login success and render success" do
      include_context "with a logged-in with admin", :patch, :update

      context "render update sucess" do
        it "render update success" do
          @product = create(:product, category_id: category.id)
          @params = {
            id: @product.id,
            product: {
              name: Faker::Name.name,
              price: rand(5..100),
              quantity: rand(1..20),
              category_id: category.id,
              description: Faker::Lorem.paragraph
            }
          }

          patch :update, params: @params

          expect(assigns(:product).name).to(eq(@params[:product][:name]))
          expect(flash[:admin_success]).to(eq(I18n.t("admin.products.update.success")))
          expect(response).to(redirect_to(admin_products_path))
        end
      end

      context "render update fails" do
        it "render update fails with" do
          @product = create(:product, category_id: category.id, name: "Iphone")
          params = {
            id: @product.id,
            product: {
              name: nil,
              price: nil,
              quantity: nil,
              category_id: category.id,
              description: nil
            }
          }

          patch :update, params: params

          expect(Product.last.name).to(eq(@product.name))
          expect(response).to(render_template(:edit))
          expect(response).to(have_http_status(:unprocessable_entity))
        end
      end
    end

    include_context "login fails", :patch, :update
  end

  describe "POST #create" do
    context "when login success and render success" do
      include_context "with a logged-in with admin", :post, :create

      context "create sucess" do
        it "create success" do
          expect(Product.count).to(eq(@initial_count + 1))
          expect(flash[:admin_success]).to(eq(I18n.t("admin.products.create.success")))
          expect(response).to(redirect_to(admin_products_path))
          expect(response).to(have_http_status(:found))
        end
      end

      context "create fails" do
        it "create fails with" do
          params = {
            product: {
              name: "",
              price: "",
              quantity: "",
              category_id: category.id,
              description: ""
            }
          }

          post(:create, params: params)

          expect(response).to(render_template(:new))
          expect(response).to(have_http_status(:unprocessable_entity))
        end
      end
    end

    include_context "login fails", :post, :create
  end

  describe "DELETE #destroy" do
    context "when login success and render success" do
      include_context "with a logged-in with admin", :delete, :destroy

      context "delete sucess" do
        it "delete success" do
          @product = create(:product, category_id: category.id)

          delete(:destroy, params: { id: @product.id })

          expect(assigns(:product).is_deleted).to(eq(true))
          expect(flash[:admin_success]).to(eq(I18n.t("admin.products.delete.success")))
          expect(response).to(redirect_to(admin_products_path))
          expect(response).to(have_http_status(:found))
        end
      end

      context "delete fails" do
        it "delete fails with" do
          delete(:destroy, params: { id: 99_999_999_999_999_999 })

          expect(flash[:admin_error]).to(eq(I18n.t("admin.products.load.not_found")))
          expect(response).to(have_http_status(:found))
          expect(response).to(redirect_to(admin_orders_path))
        end
      end
    end

    include_context "login fails", :delete, :destroy
  end
end
