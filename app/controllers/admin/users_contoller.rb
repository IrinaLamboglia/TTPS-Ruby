class Admin::UsersController < ApplicationController
      before_action :authenticate_user! # Devise
      before_action :set_usuario, only: [:edit, :update, :toggle_active]
      before_action :require_manager_or_admin, only: [:index, :show, :edit, :update]
      before_action :require_admin, only: [:new, :create, :destroy]
    
      # Listar usuarios
      def index
        @usuarios = User.includes(:role)
                        .filter_by(params)
                        .order(sort_column => sort_direction)
                        .page(params[:page])
                        .per(params.fetch(:per_page, 25))
        @roles = Role.all
      end
    
      # Formulario de creación
      def create
        @roles = Role.all
      end
    
      # Crear un nuevo usuario
      def authenticate
        @user = User.new(user_params)
    
        if @user.save
          flash[:success] = "Usuario creado correctamente"
          redirect_to usuarios_path
        else
          flash.now[:error] = @user.errors.full_messages.to_sentence
          render :create
        end
      end
    
      # Editar usuario
      def edit
        @roles = Role.all
      end
    
      # Actualizar usuario
      def update
        if @user.update(user_params)
          flash[:success] = "Usuario actualizado correctamente"
          redirect_to usuarios_path
        else
          flash.now[:error] = @user.errors.full_messages.to_sentence
          render :edit
        end
      end
    
      # Cambiar estado activo
      def toggle_active
        @user.active = !@user.active
        @user.save
        estado = @user.active ? "activado" : "bloqueado"
        flash[:success] = "El usuario ha sido #{estado}"
        redirect_to usuarios_path
      end
    
      private
    
      def set_usuario
        @user = User.find(params[:id])
      end
    
      def user_params
        params.require(:user).permit(:username, :email, :phone, :role_id, :password, :password_confirmation, :active)
      end
    
      def sort_column
        params[:sort] || "email"
      end
    
      def sort_direction
        params[:order] || "asc"
      end
    end
    