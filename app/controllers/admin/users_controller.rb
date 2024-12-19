# Controller to manage users in the admin panel.
# Provides actions to list, create, edit, update, and toggle the active status of users.
class Admin::UsersController < ApplicationController
  before_action :authenticate_user! # Devise
  before_action :set_usuario, only: [:edit, :update, :toggle_active, :edit_profile]
  before_action :require_permission, only: [:index, :new, :create, :toggle_active, :edit, :update]

  # List users
  def index
    @usuarios = User.includes(:role)
                    .order(sort_column => sort_direction)
                    .page(params[:page])
                    .per(params.fetch(:per_page, 25))
    @roles = Role.all
  end

  # Creation form
  def new
    @roles = Role.all
    @user = User.new
  end

  # Create a new user
  def create
    @user = User.new(user_params)
    @user.join_date ||= Date.today
    @roles = Role.all

    if @user.save
      redirect_to admin_users_path, notice: "Usuario creado correctamente."
    else
      render :new
    end
  end

  # Edit user
  def edit
    @roles = Role.all
  end

  # Update user
  def update
    clean_params = clean_password_params(user_params)

    if @user.update(clean_params)
      redirect_to admin_users_path, notice: "Usuario actualizado correctamente."
    else
      flash.now[:error] = "Error al actualizar el usuario."
      render :edit
    end
  end

  # Toggle active status
  def toggle_active
    @user.active = !@user.active
    if @user.save
      estado = @user.active ? "activado" : "bloqueado"
      flash.now[:success] = "El usuario ha sido #{estado}."
    else
      flash.now[:error] = "Error al cambiar el estado del usuario: #{@user.errors.full_messages.to_sentence}."
    end
    redirect_to admin_users_path
  end

  # Show user
  def show
    @user = User.find(params[:id])
  end

  # Edit current user's profile
  def edit_profile
    @user = current_user
  end

  # Update current user's profile
  def update_profile
    @user = current_user
    clean_params = clean_password_params(user_params.except(:role_id))

    if @user.update(clean_params)
      redirect_to root_path, notice: "Perfil actualizado correctamente."
    else
      flash.now[:error] = "Error al actualizar el perfil."
      render :edit_profile
    end
  end

  private

  # Set user
  def set_usuario
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path, notice: "Usuario no encontrado."
  end

  # Permitted parameters for the user
  def user_params
    params.require(:user).permit(:username, :email, :phone, :role_id, :password, :password_confirmation)
  end

  # Remove empty passwords from parameters
  def clean_password_params(params)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.except(:password, :password_confirmation)
    else
      params
    end
  end

  # Sorting column
  def sort_column
    params[:sort] || "email"
  end

  # Sorting direction
  def sort_direction
    params[:order] || "asc"
  end

  # Require permission for certain actions
  def require_permission
    unless current_user.role.has_permission?("manage_users")
      redirect_to root_path, alert: "No tienes permiso para realizar esta acción."
    end
  end
end
