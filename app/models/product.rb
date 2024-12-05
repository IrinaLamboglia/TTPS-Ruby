class Product < ApplicationRecord
  # Esta clase representa un producto en el sistema de inventario.
  # Un producto pertenece a una categoría y puede tener muchas imágenes asociadas.
  # Incluye validaciones para asegurar que los datos del producto sean correctos.
  # También soporta eliminación suave (soft delete).

  belongs_to :category
  has_many_attached :images, dependent: :destroy # Relación uno a muchos

  # Validaciones
  validates :name, presence: true
  validates :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_images, on: :create
  validate :must_have_images_on_update, on: :update

  private

  # Validación para la creación: el producto debe tener al menos una imagen.
  def must_have_images
    errors.add( :images,"debe tener al menos una imagen") unless images.attached?
  end

  # Validación para la actualización: debe haber al menos una imagen si se eliminan todas las anteriores.
  def must_have_images_on_update
    # Verificar que si el producto no tiene imágenes adjuntas (y no está eliminando ninguna imagen),
    # se agregue un error.
    if images.attached? && images.count == 0 && params[:product][:images].blank?
      errors.add(:images, "debe tener al menos una imagen o una nueva imagen subida")
    end
  end

  # Soft delete
  scope :active, -> { where(deleted_at: nil) }
  def delete
    update(deleted_at: Time.current)
    update(stock: 0) # Elimina el stock al borrar
  end
end