class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_admin
    redirect_to root_path, alert: "Acceso denegado." unless current_user&.role&.name == 'admin'
  end

  def require_manager_or_admin
    redirect_to root_path, alert: "Acceso denegado." unless %w[admin gerente].include?(current_user&.role&.name)
  end

  def require_employee_or_higher
    redirect_to root_path, alert: "Acceso denegado." unless %w[admin gerente empleado].include?(current_user&.role&.name)
  end

  before_action :authenticate_user!
end