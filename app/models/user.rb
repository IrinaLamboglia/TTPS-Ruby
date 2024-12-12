class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relación con el rol (Role)
  belongs_to :role

  before_create :set_join_date

  # Validaciones
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :role, presence: true
  validates :join_date, presence: true
  validates :password, presence: true, on: :create


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

  # Métodos para verificar roles
  def admin?
    role.name == "admin"
  end

  def manager?
    role.name == "gerente"
  end

  def employee?
    role.name == "empleado"
  end

  def active_for_authentication?
    super && active?
  end

  # Custom inactive message
  def inactive_message
    active? ? super : :blocked
  end


  private

  def set_join_date
    self.join_date ||= Date.today
  end
end
