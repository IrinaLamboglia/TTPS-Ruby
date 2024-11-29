class ProductsController < ApplicationController
  # Mostrar el catálogo público
  def index
    @categories = Category.all  # Trae todas las categorías

    @products = Product.page(params[:page]).per(9)


    # Filtro por nombre de producto
    if params[:query].present?
      @products = @products.where('name LIKE ?', "%#{params[:query]}%")
    end

    # Filtro por categoría
    if params[:category].present?
      @products = @products.where(category_id: params[:category])
    end

    # Ordenar productos
    if params[:order_by].present?
      order_column = params[:order_by] == 'price' ? :price : :name
      @products = @products.order(order_column)
    end
  end

  # Mostrar detalles de un producto específico
  def show
    @product = Product.find(params[:id])
    if @product.deleted_at.present? || @product.stock <= 0
      redirect_to products_path, alert: 'El producto no está disponible.'
    end
  end
end
