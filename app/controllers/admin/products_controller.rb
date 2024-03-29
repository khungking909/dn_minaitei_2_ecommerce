# frozen_string_literal: true

class Admin::ProductsController < Admin::AdminController
  before_action :load_product, only: %i(update edit destroy)

  def index
    @pagy, @products = pagy(filter_products, items: Settings.DIGIT_5)
    @top_10_outstanding ||= Product.product_outstanding
  end

  def edit
    @hidden_partial = true
  end

  def new
    @product = Product.new
    @hidden_partial = true
  end

  def update
    if @product.update(product_params)
      flash[:admin_success] = t("admin.products.update.success")
      redirect_to(admin_products_path)
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:admin_success] = t("admin.products.create.success")
      redirect_to(admin_products_path)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def destroy
    if @product.delete_soft
      flash[:admin_success] = t("admin.products.delete.success")
    else
      flash[:admin_error] = t("admin.products.delete.fail")
    end
    redirect_to(admin_products_path)
  end

  private

  def load_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:admin_error] = t("admin.products.load.not_found")
    redirect_to(admin_orders_path)
  end

  def filter_products
    Product.search_by_name(params.dig(:product, :search))
           .get_all_by_name_sort
  end

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :category_id, :image, :description)
  end
end
