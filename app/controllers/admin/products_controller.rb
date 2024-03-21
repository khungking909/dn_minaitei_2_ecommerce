# frozen_string_literal: true

class Admin::ProductsController < Admin::AdminController
  def index
    @pagy, @products = pagy(Product.get_all_by_name_sort, items: Settings.DIGIT_5)
  end
end
