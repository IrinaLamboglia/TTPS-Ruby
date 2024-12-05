class Admin::ProductsController < ApplicationController
  before_action :authenticate_user! # Devise
  before_action :set_product, only: [:edit, :update, :destroy, :toggle_stock,:delete_image]
  before_action :require_manager_or_admin, only: [:index, :edit, :update, :toggle_stock,:new, :create, :destroy]
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
    puts params[:product][:images]

    if @product.save
      if params[:product][:images]
        params[:product][:images].each do |image|
          @product.images.attach(image)
        end
      end

      redirect_to admin_products_path, notice: 'Producto creado exitosamente.'
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
    @product = Product.find(params[:id])
  
    if @product.update(product_params.except(:images))
      # Adjuntar nuevas imágenes si fueron enviadas
      if params[:product][:images].present?
        params[:product][:images].each do |image|
          @product.images.attach(image) if image.present?
        end
      end

      # Verificar que siempre haya al menos una imagen
      if @product.images.empty?
        flash[:error] = "El producto debe tener al menos una imagen."
        render :edit and return
      end
  
      # Si hay errores de validación, volver a la vista de edición
      if @product.errors.any?
        flash[:error] = @product.errors.full_messages.to_sentence
        render :edit
      else
        flash[:success] = "Producto actualizado correctamente"
        redirect_to admin_products_path
      end
    else
      flash[:error] = @product.errors.full_messages.to_sentence
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
    product = Product.find(params[:id]) # Encuentra el producto por ID
    image = product.images.find(params[:image_id]) # Encuentra la imagen por ID dentro del producto

    if image.purge # Intenta eliminar la imagen del almacenamiento
      render json: { success: true }, status: :ok
    else
      render json: { success: false, error: 'No se pudo eliminar la imagen' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Imagen o producto no encontrado' }, status: :not_found
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
    params.require(:product).permit(:name, :description, :price, :stock, :color, :size, :category_id, images: [])
  end

  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:order] || "asc"
  end

  def restrict_admin_modification
    if current_user.role.name == "gerente" && @user.role.name == "admin"
      flash[:alert] = "No tienes permiso para modificar un usuario con rol de Administrador."
      redirect_to admin_users_path
    end
  end
end
