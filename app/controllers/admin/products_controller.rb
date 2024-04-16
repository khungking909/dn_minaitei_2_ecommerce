# frozen_string_literal: true

class Admin::ProductsController < Admin::AdminController
  load_and_authorize_resource
  skip_load_resource only: %i(index new create)

  def index
    @pagy, @products = pagy(Product.ransack(params[:search]).result, items: Settings.DIGIT_5)
    @top_10_outstanding ||= Product.product_outstanding
  end

  def edit; end

  def new
    @product = Product.new
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

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :category_id, :image, :description)
  end
end
