class Admin::UsersController < ApplicationController
      before_action :authenticate_user! # Devise
      before_action :set_usuario, only: [:edit, :update, :toggle_active]
      before_action :require_manager_or_admin, only: [:index, :edit, :update]
      before_action :require_admin, only: [:new,:create, :toggle_active]
    


      # Listar usuarios
      def index

        @usuarios = User.includes(:role)
                        .order(sort_column => sort_direction)
                        .page(params[:page])
                        .per(params.fetch(:per_page, 25))
        @roles = Role.all
      end
    
      # Formulario de creación
      def new
        @roles = Role.all
        @user = User.all.new
      end
    
      # Crear un nuevo usuario
      def create
        @user = User.new(user_params)
        @user.join_date = Date.today unless @user.join_date.present?
    
        if @user.save
          flash[:success] = "Usuario creado correctamente"
          redirect_to admin_users_path
        else
          flash.now[:error] = @user.errors.full_messages.to_sentence
          puts @user.errors.full_messages
          render :new
        end
      end
    
      # Editar usuario
      def edit
        @roles = Role.all
      end
    
      # Actualizar usuario
      def update
        clean_params = user_params.dup

        # Eliminar contraseñas vacías de los parámetros
        clean_params = clean_params.except(:password, :password_confirmation) if clean_params[:password].blank? && clean_params[:password_confirmation].blank?


        if @user.update(clean_params)
          flash[:success] = "Usuario actualizado correctamente"
          redirect_to admin_users_path
        else
          flash.now[:error] = @user.errors.full_messages.to_sentence
          puts @user.errors.full_messages
          render :edit
        end
      end
    
      # Cambiar estado activo
      def toggle_active
        @user.active = !@user.active
        @user.save
        estado = @user.active ? "activado" : "bloqueado"
        flash[:success] = "El usuario ha sido #{estado}"
        redirect_to admin_users_path
      end

      def show
        @user = User.find(params[:id])
      end
    
      private
    
      def set_usuario
        @user = User.find(params[:id])
      end
    
      def user_params
        params.require(:user).permit(:username, :email, :phone, :role_id, :password, :password_confirmation)
      end
    
      def sort_column
        params[:sort] || "email"
      end
    
      def sort_direction
        params[:order] || "asc"
      end

      
    end
    