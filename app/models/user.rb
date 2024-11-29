class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relación con el rol (Role)
  belongs_to :role

  # Validaciones
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :role, presence: true
  validates :join_date, presence: true

  scope :filter_by_email, ->(email) { where("email ILIKE ?", "%#{email}%") if email.present? }
  scope :filter_by_active, ->(activo) { where(active: activo == "si") if activo.present? }
  scope :filter_by_role, ->(rol) { joins(:role).where(roles: { name: rol }) if rol.present? }
  
  # Métodos de desactivación
  def activate!
    update(active: true)
  end

  def deactivate!
    update(active: false, password: SecureRandom.hex)
  end
end
