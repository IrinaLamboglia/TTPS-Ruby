class SaleItem < ApplicationRecord
  # Esta clase representa un producto vendido en una venta.
  # Incluye validaciones para asegurar que los datos del producto vendido sean correctos.
  # También soporta eliminación suave (soft delete).
  
  belongs_to :sale
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end