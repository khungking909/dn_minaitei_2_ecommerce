# frozen_string_literal: true

module CategoriesHelper
  def all_select_of_category
    Category.pluck(:name, :id)
  end
end
