# frozen_string_literal: true

module ProductsHelper
  def product_image_tag(product)
    if product.image.attached?
      image_tag(product.image.variant(:display), class: "product-image", alt: product.name)
    else
      image_tag(Settings.NO_IMAGE, class: "product-image")
    end
  end

  def render_comments(comments)
    if comments.present?
      render(partial: "products/comment", locals: { comments: comments })
    else
      content_tag(:p, t("products.no_comment"))
    end
  end

  def all_select_year_product
    [
      [t("products.filter.newest"), Time.current.year],
      [t("products.filter.hoting"), Time.current.year - 1],
      [t("products.filter.lowering_prices"), Time.current.year - 2]
    ]
  end

  def all_select_price_search_product
    [
      [t("products.filter.all"), ""],
      [t("products.filter.range_5_to_10"), Settings.range_5_to_10],
      [t("products.filter.range_10_to_20"), Settings.range_10_to_20],
      [t("products.filter.range_20_to_50"), Settings.range_20_to_50],
      [t("products.filter.range_50_to_100"), Settings.range_50_to_100]
    ]
  end
end
