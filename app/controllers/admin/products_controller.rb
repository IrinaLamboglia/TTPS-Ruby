class Admin::ProductsController < Admin::BaseController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Producto creado exitosamente"
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "Producto actualizado exitosamente"
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path, notice: "Producto eliminado exitosamente"
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category_id, images: [])
  end
end
