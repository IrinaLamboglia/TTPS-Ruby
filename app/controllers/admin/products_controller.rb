# Controlador para gestionar productos en el panel de administración.
# Incluye acciones para listar, crear, editar, actualizar, eliminar, y gestionar el stock de los productos.
class Admin::ProductsController < ApplicationController
  before_action :authenticate_user! # Devise
  before_action :set_product, only: [:edit, :update, :destroy, :toggle_stock, :delete_image]
  before_action :require_permission, except: [:show] # Aplicar permisos excepto en acciones públicas

  # Listar productos
  def index
    @products = Product.order("#{sort_column} #{sort_direction}")
                       .page(params[:page])
                       .per(params.fetch(:per_page, 25))
    @categories = Category.all
  end

  # Mostrar producto
  def show
    @product = Product.find_by(id: params[:id])
    redirect_to products_path, alert: "El producto no existe." unless @product
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
      redirect_to admin_products_path, notice: "Producto creado exitosamente."
    else
      cargar_categorias
      flash.now[:error] = @product.errors.full_messages.to_sentence
      render :new
    end
  end

  # Editar producto
  def edit
    cargar_categorias
  end

  # Actualizar producto
  def update
    if @product.update(product_params.except(:images))
      # Adjuntar nuevas imágenes, si se enviaron
      if params[:product][:images].present?
        @product.images.attach(params[:product][:images])
      end

      # Verificar que el producto conserve al menos una imagen
      if @product.images.attached?
        redirect_to admin_products_path, notice: "Producto actualizado exitosamente."
      else
        flash.now[:error] = "El producto debe tener al menos una imagen."
        cargar_categorias
        render :edit
      end
    else
      # Manejar errores y volver a la vista de edición
      flash.now[:error] = @product.errors.full_messages.to_sentence
      cargar_categorias
      render :edit
    end
  end

  # Eliminar producto (lógico)
  def destroy
    @product.update(deleted_at: Time.current, stock: 0)
    redirect_to admin_products_path, notice: "Producto eliminado lógicamente (stock puesto en 0)."
  end

  # Eliminar imagen del producto
  def delete_image
    image = @product.images.find_by(id: params[:image_id])
    if image&.purge
      render json: { success: true }, status: :ok
    else
      render json: { success: false, error: "No se pudo eliminar la imagen" }, status: :unprocessable_entity
    end
  end

  # Cambiar stock del producto
  def toggle_stock
    if @product.update(stock: params[:stock].to_i)
      flash[:success] = "Stock actualizado correctamente."
    else
      flash[:error] = @product.errors.full_messages.to_sentence
    end
    redirect_to admin_products_path
  end

  # Obtener precio del producto (API)
  def price
    product = Product.find(params[:id])
    render json: { price: product.price }
  end

  private

  # Establecer producto
  def set_product
    @product = Product.find_by(id: params[:id])
    redirect_to admin_products_path, alert: "Producto no encontrado." unless @product
  end

  # Cargar categorías para formularios
  def cargar_categorias
    @categories = Category.all
  end

  # Parámetros permitidos para el producto
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :color, :size, :category_id, images: [])
  end

  # Columna de ordenación (asegurar seguridad)
  def sort_column
    %w[name price stock].include?(params[:sort]) ? params[:sort] : "name"
  end

  # Dirección de ordenación (asegurar seguridad)
  def sort_direction
    %w[asc desc].include?(params[:order]) ? params[:order] : "asc"
  end

  # Requerir permiso para ciertas acciones
  def require_permission
    unless current_user.role&.has_permission?("manage_products")
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end
end
