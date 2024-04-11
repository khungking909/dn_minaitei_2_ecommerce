# frozen_string_literal: true

class ProductsController < ApplicationController
  load_resource only: :show
  authorize_resource only: %i(index show)
  before_action :show_slider, only: %i[index show]
  before_action :load_categories, only: :index

  def index
    @pagy, @products = pagy(filter_products, items: Settings.PAGE_9)
    @product_outstandings = Product.product_outstanding
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
           .get_all_by_name_sort
  end
end
