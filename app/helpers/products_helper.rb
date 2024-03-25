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
      render("products/comment", collection: comments)
    else
      content_tag(:p, t("products.no_comment"))
    end
  end
end
