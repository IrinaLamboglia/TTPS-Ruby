class Admin::ProductsController < ApplicationController
  before_action :authenticate_user! # Devise
  before_action :set_product, only: [:edit, :update, :destroy, :toggle_stock]
  before_action :require_manager_or_admin, only: [:index, :edit, :update, :toggle_stock]
  before_action :require_admin, only: [:new, :create, :destroy]

  # Listar productos
  def index
    @products = Product.order(sort_column => sort_direction)
                       .page(params[:page])
                       .per(params.fetch(:per_page, 25))
    @categories = Category.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    unless @product
      redirect_to products_path, alert: "El producto no existe."
    end 
  end

  # Formulario de creación
  def new
    @product = Product.new
    @categories = Category.all
  end

  # Crear un nuevo producto
  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:success] = "Producto creado correctamente"
      redirect_to admin_products_path
    else
      flash.now[:error] = @product.errors.full_messages.to_sentence
      puts @product.errors.full_messages
      render :new
    end
  end

  # Editar producto
  def edit
    @categories = Category.all
  end

  # Actualizar producto
  def update
    if @product.update(product_params)
      flash[:success] = "Producto actualizado correctamente"
      redirect_to admin_products_path
    else
      flash.now[:error] = @product.errors.full_messages.to_sentence
      render :edit
    end
  end

  # Eliminar producto (lógico)
  def destroy
    @product.update(deleted_at: Time.current, stock: 0)
    flash[:success] = "Producto eliminado lógicamente (stock puesto en 0)"
    redirect_to admin_products_path
  end

  def delete_image
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_back fallback_location: admin_product_path(image.record), notice: "Imagen eliminada con éxito."
  end

  # Cambiar stock del producto
  def toggle_stock
    new_stock = params[:stock].to_i
    if @product.update(stock: new_stock)
      flash[:success] = "Stock actualizado correctamente a #{new_stock}"
    else
      flash[:error] = @product.errors.full_messages.to_sentence
    end
    redirect_to admin_products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :color, :size, :category_id, :images: [])
  end

  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:order] || "asc"
  end
end
