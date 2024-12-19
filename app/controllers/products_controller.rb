class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  # Display the public catalog
  def index
    Category.all  # Fetches all categories

    # Fetches all products with available stock


    # Filter by product name
    if params[:query].present?
      @products = @products.where("name LIKE ?", "%#{params[:query]}%")
    end

    # Filter by category
    if params[:category].present?
      @products = @products.where(category_id: params[:category])
    end

    # Sort products
    if params[:order_by].present?
      order_column = params[:order_by] == "price" ? :price : :name
      @products = @products.order(order_column)
    end
  end


  # Mostrar detalles de un producto específico
  def show
    @product = Product.find(params[:id])
    if  @product.stock <= 0
      redirect_to products_path, alert: "El producto no está disponible."
    end
  end
end
