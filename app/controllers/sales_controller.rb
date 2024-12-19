# Controlador para gestionar ventas en la aplicación.
class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :cancel]
  before_action :require_permission
  before_action :load_customers_and_products, only: [:new, :create]

  # Listar ventas
  def index
    @sales = Sale.page(params[:page]).per(10)
  end

  # Mostrar venta
  def show; end

  # Formulario de creación
  def new
    @sale = Sale.new
    @sale.sale_items.build
  end

  # Crear una nueva venta
  def create
    @sale = Sale.new(sale_params)

    ActiveRecord::Base.transaction do
      if @sale.save
        update_product_stock(@sale)
        redirect_to @sale, notice: "Venta creada exitosamente."
      else
        render_with_error(:new, "Hubo un error al crear la venta.")
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render_with_error(:new, "Error: #{e.message}")
  end

  # Formulario de edición
  def edit; end

  # Actualizar venta
  def update
    if @sale.update(sale_params)
      redirect_to @sale, notice: "Venta actualizada exitosamente."
    else
      render_with_error(:edit, "Hubo un error al actualizar la venta.")
    end
  end

  # Eliminar venta
  def destroy
    @sale.destroy!
    redirect_to sales_path, notice: "Venta eliminada exitosamente.", status: :see_other
  end

  # Cancelar venta
  def cancel
    ActiveRecord::Base.transaction do
      @sale.update!(deleted_at: Time.current)
      restore_product_stock(@sale)
    end

    redirect_to sales_path, notice: "Venta cancelada exitosamente."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to sales_path, alert: "Error al cancelar la venta: #{e.message}"
  end

  private

  # Cargar clientes y productos disponibles
  def load_customers_and_products
    @customers = User.where(role_id: Role.find_by(name: "comun"))
    @products = Product.where.not(stock: 0)
  end

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
      raise ActiveRecord::RecordInvalid.new(sale) if product.stock < item.quantity

      product.decrement!(:stock, item.quantity)
    end
  end

  # Restaurar stock del producto
  def restore_product_stock(sale)
    sale.sale_items.each do |item|
      product = item.product
      product.increment!(:stock, item.quantity)
    end
  end

  # Renderizar con errores y datos preestablecidos
  def render_with_error(view, message)
    flash.now[:alert] = message
    render view, status: :unprocessable_entity
  end

  # Requerir permiso para ciertas acciones
  def require_permission
    unless current_user.role.has_permission?("manage_sales")
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end
end
