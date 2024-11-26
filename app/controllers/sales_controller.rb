class SalesController < ApplicationController
  before_action :require_manager_or_admin, only: [:index]
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  def index
    @sales = Sale.includes(:user, :sale_items).all
  end

  def show
    # La venta se encuentra con el before_action :set_sale
  end

  def new
    @sale = Sale.new
    @sale.sale_items.build
  end

  def create
    @sale = Sale.new(sale_params)
    @sale.user = current_user
    if @sale.save
      update_stock
      redirect_to sales_path, notice: "Venta registrada exitosamente."
    else
      flash.now[:alert] = "Error al registrar la venta. Revisa los campos."
      render :new
    end
  end

  def edit
    # La venta se encuentra con el before_action :set_sale
  end

  def update
    if @sale.update(sale_params)
      adjust_stock_on_update
      redirect_to sale_path(@sale), notice: "Venta actualizada exitosamente."
    else
      flash.now[:alert] = "Error al actualizar la venta. Revisa los campos."
      render :edit
    end
  end

  def destroy
    @sale.cancel!
    redirect_to sales_path, notice: "Venta cancelada exitosamente."
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(:total, sale_items_attributes: %i[id product_id quantity price _destroy])
  end

  def update_stock
    @sale.sale_items.each do |item|
      product = item.product
      product.update(stock: product.stock - item.quantity)
    end
  end

  def adjust_stock_on_update
    @sale.sale_items.each do |item|
      previous_quantity = item.quantity_before_last_save || 0
      quantity_difference = item.quantity - previous_quantity
      product = item.product
      product.update(stock: product.stock - quantity_difference)
    end
  end

  def restore_stock
    @sale.sale_items.each do |item|
      product = item.product
      product.update(stock: product.stock + item.quantity)
    end
  end
end