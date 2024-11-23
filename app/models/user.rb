class User < ApplicationRecord
    # Esta clase representa un usuario de la aplicación.
    # Incluye validaciones para asegurar que los datos del usuario sean correctos.
    # También soporta eliminación suave (soft delete).

    belongs_to :role

    has_secure_password

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :phone, presence: true
    validates :role, presence: true
    validates :join_date, presence: true

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    # Métodos de desactivación

    def activate!
        update(active: true)
    end

    def deactivate
      update(active: false, password: SecureRandom.hex)
    end

    # Scope para usuarios activos
    scope :active, -> { where(active: true) }
end
