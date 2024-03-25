# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ProductsController, type: :controller) do
  describe "GET #index" do
    let!(:products) do
      FactoryBot.create_list(:product, Settings.DIGIT_10)
    end

    before { get :index }

    it "assigns @pagy and @products" do
      expect(assigns(:pagy).count).to(eq(Settings.DIGIT_10))
      products_per_page = Settings.PAGE_9
      expect(assigns(:products).count).to(eq(products_per_page))
    end

    it "renders the index template" do
      expect(response).to(render_template(:index))
    end
  end

  describe "GET #show" do
    context "when product exists" do
      let!(:product) { FactoryBot.create(:product) }

      before do
        get :show, params: { id: product.id }
      end

      it "assigns the requested product to @product" do
        expect(assigns(:product)).to(eq(product))
      end

      it "renders the show template" do
        expect(response).to(render_template("show"))
      end
    end

    context "when product does not exist" do
      before { get :show, params: { id: 0 } }

      it "flash error if product doesn't exist" do
        expect(flash[:error]).to(eq(I18n.t("products.load.error")))
      end

      it "redirects to products_path if product is not found" do
        expect(response).to(redirect_to(products_path))
      end
    end
  end
end
