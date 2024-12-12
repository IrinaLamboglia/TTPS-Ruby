class ImagesController < ApplicationController
    before_action :set_product

    # Crear una imagen vinculada a un producto
    def create
      @image = @product.images.attach(params[:image]) # Active Storage
      if @image.persisted?
        redirect_to @product, notice: "Imagen subida con éxito."
      else
        redirect_to @product, alert: "Error al subir la imagen."
      end
    end

    # Eliminar una imagen específica
    def destroy
      @image = @product.images.find(params[:id])
      if @image.purge
        redirect_to @product, notice: "Imagen eliminada con éxito."
      else
        redirect_to @product, alert: "Error al eliminar la imagen."
      end
    end

    private

    def set_product
      @product = Product.find(params[:product_id])
    end
end
