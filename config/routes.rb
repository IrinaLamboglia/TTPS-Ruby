Rails.application.routes.draw do

  devise_for :users
  # Ruta raíz
  root "storefront#index" # Página principal para el storefront público


  # Storefront (vista pública)
  resources :storefront, only: [:index]

  # Rutas principales para productos y ventas
  resources :products
  resources :sales

  # Administración (requiere autenticación y roles)
  namespace :admin do
    resources :products
    resources :sales
    resources :users, except: [:destroy] do
      member do
        post :toggle_active
        patch :update
      end
      collection do
        get :index
        get :create
        post :authenticate
      end
    end
  end

  # Rutas para roles y categorías (opcional)
  resources :roles, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # Subrecursos para imágenes (vinculadas a productos)
  resources :products do
    resources :images, only: [:create, :destroy]
  end

  # Endpoint de monitoreo de salud
  get "up", to: "rails/health#show", as: :rails_health_check

  devise_scope :user do
    get '/login_as_admin', to: 'sessions#login_as_admin' if Rails.env.development?
  end
end