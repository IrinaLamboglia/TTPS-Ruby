class Image < ApplicationRecord
  # Esta clase representa una imagen asociada a un producto.
  # Incluye validaciones para asegurar que los datos de la imagen sean correctos.
  # También soporta eliminación suave (soft delete).
  
  belongs_to :product

  # Validación de URL
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'debe ser una URL válida' }
end
