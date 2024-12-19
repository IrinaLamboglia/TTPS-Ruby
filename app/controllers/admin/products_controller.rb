# Controller to manage products in the admin panel.
# Includes actions to list, create, edit, update, delete, and manage product stock.
class Admin::ProductsController < ApplicationController
  before_action :authenticate_user! # Devise
  before_action :set_product, only: [:edit, :update, :destroy, :toggle_stock, :delete_image]
  before_action :require_permission, except: [:show] # Aplicar permisos excepto en acciones públicas

  # List products
  def index
    @products = Product.order("#{sort_column} #{sort_direction}")
                       .page(params[:page])
                       .per(params.fetch(:per_page, 25))
    @categories = Category.all
  end

  # Show product
  def show
    @product = Product.find_by(id: params[:id])
    redirect_to products_path, alert: "El producto no existe." unless @product
  end

  # New product form
  def new
    @product = Product.new
    @categories = Category.all
  end

  # Create a new product
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_products_path, notice: "Producto creado exitosamente."
    else
      cargar_categorias
      flash.now[:error] = @product.errors.full_messages.to_sentence
      render :new
    end
  end

  # Edit product
  def edit
    cargar_categorias
  end

  # Update product
  def update
    if @product.update(product_params.except(:images))
      # Attach new images, if any were sent
      if params[:product][:images].present?
        @product.images.attach(params[:product][:images])
      end

      # Ensure the product retains at least one image
      if @product.images.attached?
        redirect_to admin_products_path, notice: "Producto actualizado exitosamente."
      else
        flash.now[:error] = "El producto debe tener al menos una imagen."
        cargar_categorias
        render :edit
      end
    else
      # Handle errors and return to the edit view
      flash.now[:error] = @product.errors.full_messages.to_sentence
      cargar_categorias
      render :edit
    end
  end

  # Delete product (logical)
  def destroy
    @product.update(deleted_at: Time.current, stock: 0)
    redirect_to admin_products_path, notice: "Producto eliminado lógicamente (stock puesto en 0)."
  end

  # Delete product image
  def delete_image
    image = @product.images.find_by(id: params[:image_id])
    if image&.purge
      render json: { success: true }, status: :ok
    else
      render json: { success: false, error: "No se pudo eliminar la imagen" }, status: :unprocessable_entity
    end
  end

  # Change product stock
  def toggle_stock
    if @product.update(stock: params[:stock].to_i)
      flash[:success] = "Stock actualizado correctamente."
    else
      flash[:error] = @product.errors.full_messages.to_sentence
    end
    redirect_to admin_products_path
  end

  # Get product price (API)
  def price
    product = Product.find(params[:id])
    render json: { price: product.price }
  end

  private

  # Set product
  def set_product
    @product = Product.find_by(id: params[:id])
    redirect_to admin_products_path, alert: "Producto no encontrado." unless @product
  end

  # Load categories for forms
  def cargar_categorias
    @categories = Category.all
  end

  # Permitted parameters for the product
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :color, :size, :category_id, images: [])
  end

  # Sorting column (ensure security)
  def sort_column
    %w[name price stock].include?(params[:sort]) ? params[:sort] : "name"
  end

  # Sorting direction (ensure security)
  def sort_direction
    %w[asc desc].include?(params[:order]) ? params[:order] : "asc"
  end

  # Require permission for certain actions
  def require_permission
    unless current_user.role&.has_permission?("manage_products")
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end
end
