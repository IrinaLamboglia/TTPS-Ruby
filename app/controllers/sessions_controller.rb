# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Bienvenido, #{user.name}."
    else
      flash.now[:alert] = "Email o contraseña incorrectos."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Sesión cerrada."
  end

end
