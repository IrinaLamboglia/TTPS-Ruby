class Image < ApplicationRecord
  # Esta clase representa una imagen asociada a un producto.
  # Incluye validaciones para asegurar que los datos de la imagen sean correctos.
  # También soporta eliminación suave (soft delete).

  belongs_to :product
  has_one_attached :file

  # Validaciones
  validates :file, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }
end