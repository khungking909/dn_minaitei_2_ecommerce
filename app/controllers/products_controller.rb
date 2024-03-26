# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :load_product, only: :show
  before_action :show_slider, only: %i[index show]
  before_action :load_categories, only: :index

  def index
    @pagy, @products = pagy(filter_products, items: Settings.PAGE_9)
  end

  def new
    @product = Product.new
  end

  def create
    product = Product.new(product_params)
    if product.save
      flash[:success] = t("products.create.success")
      redirect_to(products_path)
    else
      flash.now[:error] = t("products.create.error")
      render(:new)
    end
  end

  def show; end

  private

  def load_categories
    @categories = Category.pluck(:name, :id).map { |category| [category[0], category[1]] }
  end

  def show_slider
    @slider = params[:search].blank? && params[:category_id].blank? && params[:price_range].blank?
  end

  def filter_products
    price_range = Product.parse_price_range(params[:price_range])
    Product.search_by_name(params[:search])
           .sort_by_category(params[:category_id])
           .sort_by_range_price(*price_range.values)
           .newest
  end

  def load_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:error] = t("products.load.error")
    redirect_to(products_path)
  end

  def product_params
    params.require(:product).permit(:name, :price, :image)
  end
end
