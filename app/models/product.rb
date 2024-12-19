class Product < ApplicationRecord
  # This class represents a product in the inventory system.
  # A product belongs to a category and can have many associated images.
  # It includes validations to ensure that the product data is correct.
  # It also supports soft deletion.

  belongs_to :category
  has_many_attached :images, dependent: :destroy # Relación uno a muchos
  has_many :sale_items
  has_many :sales, through: :sale_items

  # Validaciones
  validates :name, presence: true
  validates :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_images, on: :create
  validate :must_have_images_on_update, on: :update

  private

  # Validation for creation: the product must have at least one image.
  def must_have_images
    errors.add(:images, "debe tener al menos una imagen") unless images.attached?
  end

  # Validation for update: there must be at least one image if all previous ones are removed.
  def must_have_images_on_update
    # Check that if the product does not have attached images (and is not deleting any images),
    # an error is added.
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
