# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def create
    user = User.find_by(email: params[:user][:email])
  
    if user && !user.active?
      set_flash_message! :alert, :blocked
      redirect_to new_user_session_path
    elsif user && user.role.name == 'comun'
      set_flash_message! :alert, :role_restricted
      redirect_to new_user_session_path
    else
      super
    end
  end
  
end
