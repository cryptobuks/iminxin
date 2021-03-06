class MxApps::Store::ProductsController < MxApps::Store::BaseController
  before_action :add_index_breadcrumb
  before_action :load_product, only: [:edit, :update]

  def index
    @products = current_mx_app.products.page(params[:page])
  end

  def new
    add_breadcrumb '新建商品', new_mx_app_store_product_path(current_mx_app)
    @product = current_mx_app.products.new
  end

  def create
    @product = current_mx_app.products.new(product_params)
    if @product.save
      redirect_to mx_app_store_products_path(current_mx_app)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to mx_app_store_products_path(current_mx_app)
    else
      render :edit
    end
  end

  private

  def load_product
    @product = current_mx_app.products.find_by(number: params[:number])
  end

  def product_params
    params.require(:store_app_product).permit(:name, :introduction, :cover, store_app_product_price_attributes: [:currency_id, :value, :id])
  end

  def add_index_breadcrumb
    add_breadcrumb '商品管理', mx_app_store_products_path(current_mx_app)
  end
end
