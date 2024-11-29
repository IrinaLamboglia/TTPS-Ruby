# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_product, only: %i[edit update destroy]

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Producto creado exitosamente."
    else
      render :new
    end
  end
  
  def show
    @product = Product.find_by(id: params[:id])
    unless @product
      redirect_to products_path, alert: "El producto no existe."
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Producto actualizado."
    else
      render :edit
    end
  end

  def destroy
    @product.update(stock: 0)
    redirect_to products_path, notice: "Producto eliminado (borrado lógico)."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category, images: [])
  end
end
