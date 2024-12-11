class Sale < ApplicationRecord
  belongs_to :employee, class_name: 'User'
  belongs_to :customer, class_name: 'User'
  has_many :sale_items, inverse_of: :sale, dependent: :destroy
  has_many :products, through: :sale_items

  accepts_nested_attributes_for :sale_items, allow_destroy: true

  validates :date, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :employee, :customer, presence: true
  validate :must_have_sale_items, :validate_stock

  before_validation :calculate_total
  before_save :calculate_total

  scope :active, -> { where(deleted_at: nil) }

  private

  # Calcula el total sumando los subtotales de cada item
  def calculate_total
    self.total = sale_items.sum { |item| item.quantity.to_f * item.price.to_f }
  end

  def validate_stock
    sale_items.each do |item|
      next unless item.product

      if item.product.stock < item.quantity
        errors.add(:base, "Stock insuficiente para el producto #{item.product.name}.")
      end
    end
  end

  def must_have_sale_items
    errors.add(:base, 'La venta debe tener al menos un producto.') if sale_items.empty?
  end
end