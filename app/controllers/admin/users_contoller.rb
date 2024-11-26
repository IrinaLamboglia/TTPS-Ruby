class Admin::UsersController < ApplicationController
    before_action :set_user, only: [:update, :deactivate]
  
    def index
      @users = User.all
    end

    def new
        @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: 'Usuario creado exitosamente.'
      else
        render :new
      end
    end

    def edit
        @user = User.find(params[:id])
    end
  
    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Usuario actualizado exitosamente.'
      else
        render :edit
      end
    end
  
    def deactivate
      @user = User.find(params[:id])
      @user.deactivate
      redirect_to admin_users_path, notice: 'Usuario desactivado exitosamente.'
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:username, :email, :phone, :password, :role_id, :join_date)
    end
  end