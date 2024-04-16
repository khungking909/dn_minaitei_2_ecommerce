# frozen_string_literal: true

class ProductsController < ApplicationController
  load_resource only: :show
  authorize_resource only: %i(index show)
  before_action :show_slider, only: %i[index show]
  before_action :load_categories, only: :index

  def index
    @pagy, @products = pagy(Product.ransack(params[:search]).result.price_sort, items: Settings.PAGE_9)
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
end
