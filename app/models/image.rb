class Image < ApplicationRecord
  belongs_to :product
  has_one_attached :file

  # Validaciones personalizadas
  validate :acceptable_image

  private

  def acceptable_image
    return unless file.attached?

    # Verifica si el archivo es una imagen
    unless file.blob.content_type.starts_with?("image/")
      errors.add(:file, "Debe ser una imagen")
    end

    # Verifica el tamaño del archivo
    if file.blob.byte_size > 5.megabytes
      errors.add(:file, "El tamaño de la imagen debe ser menor a 5MB")
    end
  end
end
