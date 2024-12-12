class StorefrontController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
  def index
    @categories = Category.all
    @products = if params[:category_id]
                  Product.where(category_id: params[:category_id], stock: 0..Float::INFINITY)
    elsif params[:search]
                  Product.where("name LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    else
                  Product.where(stock: 0..Float::INFINITY)
    end
  end
end
