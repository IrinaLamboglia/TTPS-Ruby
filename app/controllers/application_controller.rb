# Controlador base para la aplicación.
# Proporciona métodos auxiliares y filtros de autenticación y autorización.
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  # Obtener el usuario actual
  def current_user
    super.tap do |user|
      puts "Current user: #{user.inspect}"
    end
  end

  # Verificar si el usuario está logueado
  def logged_in?
    current_user.present?
  end

  # Requerir que el usuario sea administrador
  def require_admin
    redirect_to root_path, alert: "Acceso denegado." unless current_user&.role&.name == "admin"
  end

  # Requerir que el usuario sea gerente o administrador
  def require_manager_or_admin
    redirect_to root_path, alert: "Acceso denegado." unless %w[admin gerente].include?(current_user&.role&.name)
  end

  # Requerir que el usuario sea empleado o de un rol superior
  def require_employee_or_higher
    redirect_to root_path, alert: "Acceso denegado." unless %w[admin gerente empleado].include?(current_user&.role&.name)
  end

  before_action :authenticate_user!
end