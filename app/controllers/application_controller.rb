# Base controller for the application.
# Provides helper methods and authentication/authorization filters.
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  # Retrieve the current user
  def current_user
    super.tap do |user|
      puts "Current user: #{user.inspect}"
    end
  end

  # Check if the user is logged in
  def logged_in?
    current_user.present?
  end

  # Require the user to be an admin
  def require_admin
    redirect_to root_path, alert: "Acceso denegado." unless current_user&.role&.name == "admin"
  end

  # Require the user to be a manager or admin
  def require_manager_or_admin
    redirect_to root_path, alert: "Acceso denegado." unless %w[admin gerente].include?(current_user&.role&.name)
  end

  # Requerir que el usuario sea empleado o de un rol superior
  def require_employee_or_higher
    redirect_to root_path, alert: "Acceso denegado." unless %w[admin gerente empleado].include?(current_user&.role&.name)
  end

  before_action :authenticate_user!
end