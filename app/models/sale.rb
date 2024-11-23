class Sale < ApplicationRecord
  # Esta clase representa una venta en el sistema.
  # Incluye validaciones para asegurar que los datos de la venta sean correctos.
  # También soporta eliminación suave (soft delete).

  belongs_to :employee, class_name: 'User'
  belongs_to :customer
  has_many :sale_items, dependent: :destroy
  has_many :products, through: :sale_items

  accepts_nested_attributes_for :sale_items

  validates :date, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :employee, presence: true
  validates :customer, presence: true

  # Soft delete
  scope :active, -> { where(deleted_at: nil) }
  def cancel!
    update(deleted_at: Time.current)
    sale_items.each do |item|
      product = item.product
      product.stock += item.quantity
      product.save!
    end
  end
end