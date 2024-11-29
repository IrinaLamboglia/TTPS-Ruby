class SessionsController < Devise::SessionsController
    # Puedes personalizar las acciones si lo necesitas

    def login_as_admin
      # Asegura que el mapeo de Devise esté configurado explícitamente
      request.env["devise.mapping"] = Devise.mappings[:user]
  
      admin = User.find_by(email: 'admin@example.com') # Ajusta este correo según tu usuario administrador
      if admin
        sign_in admin
        redirect_to root_path, notice: 'Sesión iniciada como administrador.'
      else
        redirect_to new_user_session_path, alert: 'No se encontró el administrador.'
      end
    end
    
    def new
      super
    end
  
    def create
      super
    end
  
    def destroy
      super
    end
  end