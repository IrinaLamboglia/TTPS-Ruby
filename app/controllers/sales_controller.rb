# Controlador para gestionar ventas en la aplicación.
# Proporciona acciones para listar, crear, editar, actualizar, eliminar y cancelar ventas.
class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :cancel]
  before_action :require_permission

  # Listar ventas
  def index
    @sales = Sale.page(params[:page]).per(10)
  end

  # Mostrar venta
  def show
  end

  # Formulario de creación
  def new
    @sale = Sale.new
    @sale.sale_items.build
    @customers = User.where(role_id: Role.find_by(name: "comun"))
    @products = Product.where.not(stock: 0)
  end

  # Formulario de edición
  def edit
  end

  # Crear una nueva venta
  def create
    # Filtra los elementos vacíos
    filtered_params = sale_params

    @sale = Sale.new(filtered_params)

    ActiveRecord::Base.transaction do
      if @sale.save
        @sale.sale_items.each do |sale_item|
          product = sale_item.product
          product.update!(stock: product.stock - sale_item.quantity)
        end
        redirect_to @sale, notice: "Venta creada exitosamente."
      else
        @customers = User.where(role_id: Role.find_by(name: "comun"))
        @products = Product.where("stock > 0") # Filtrar productos con al menos un stock disponible
        flash.now[:alert] = "Hubo un error al crear la venta."
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    @customers = User.where(role_id: Role.find_by(name: "comun"))
    @products = Product.where("stock > 0") # Filtrar productos con al menos un stock disponible
    flash.now[:alert] = "Error: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  # Actualizar venta
  def update
  end

  # Eliminar venta
  def destroy
    @sale.destroy!
    redirect_to sales_path, notice: "Venta eliminada exitosamente.", status: :see_other
  end

  # Cancelar venta
  def cancel
    @sale = Sale.find(params[:id])

    ActiveRecord::Base.transaction do
      @sale.update!(deleted_at: Time.current) # Marca la venta como cancelada
      restore_product_stock(@sale)           # Restaura el stock
    end

    redirect_to sales_path, notice: "Venta cancelada exitosamente."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to sales_path, alert: "Error al cancelar la venta: #{e.message}"
  end

  private

  # Establecer venta
  def set_sale
    @sale = Sale.find(params[:id])
  end

  # Parámetros permitidos para la venta
  def sale_params
    params.require(:sale).permit(
      :customer_id,
      :employee_id,
      :date,
      sale_items_attributes: [:product_id, :quantity, :price]
    )
  end

  # Actualizar stock del producto
  def update_product_stock(sale)
    sale.sale_items.each do |item|
      product = item.product
      if product.stock < item.quantity
        raise ActiveRecord::RecordInvalid.new(sale)
      end
      product.update!(stock: product.stock - item.quantity)
    end
  end

  # Restaurar stock del producto
  def restore_product_stock(sale)
    sale.sale_items.each do |item|
      product = item.product
      product.update!(stock: product.stock + item.quantity)
    end
  end

  # Requerir permiso para ciertas acciones
  def require_permission
    unless current_user.role.has_permission?("manage_sales")
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end
end