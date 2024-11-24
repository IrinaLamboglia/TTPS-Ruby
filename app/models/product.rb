class Product < ApplicationRecord
  # Esta clase representa un producto en el sistema de inventario.
  # Un producto pertenece a una categoría y puede tener muchas imágenes asociadas.
  # Incluye validaciones para asegurar que los datos del producto sean correctos.
  # También soporta eliminación suave (soft delete).
  
  belongs_to :category
  has_many :images, dependent: :destroy # Relación uno a muchos

  # Validaciones
  validates :name, presence: true
  validates :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates_associated :images # Valida que las imágenes asociadas sean válidas

  validate :must_have_at_least_one_image

  private   
  def must_have_at_least_one_image
    errors.add(:images, "debe tener al menos una imagen") if images.empty?
  end

  # Soft delete
  scope :active, -> { where(deleted_at: nil) }
  def delete
    update(deleted_at: Time.current)
    update(stock: 0) # Elimina el stock al borrar
  end
end

