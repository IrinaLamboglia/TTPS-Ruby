class StorefrontController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.where("stock > 0") # Productos destacados
  end
end
