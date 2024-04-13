# frozen_string_literal: true

module CategoriesHelper
  def all_select_of_category
    all_select = Category.pluck(:name, :id)
    all_select.unshift([t("products.filter.all"), ""])
  end
end
