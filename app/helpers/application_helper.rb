# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def full_title(page_title = "")
    default_title = t("default_title")
    page_title.empty? ? default_title : "#{default_title} | #{page_title}"
  end

  def uppercase(string)
    string.upcase
  end
end
