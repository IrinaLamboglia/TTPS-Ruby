class Category < ApplicationRecord
    # Esta clase representa una categoría de productos.
    # Incluye validaciones para asegurar que los datos de la categoría sean correctos.
    # Una categoría puede tener muchos productos asociados.

    has_many :products, dependent: :destroy

    validates :name, presence: true, uniqueness: true
end
