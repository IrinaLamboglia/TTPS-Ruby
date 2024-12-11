Rails.application.routes.draw do
  get "sale/index"
  get "sale/show"
  get "sale/new"
  get "sale/create"
  get "sale/cancel"
  get "sale/set_sale"

  devise_for :users, controllers: {
  sessions: 'sessions'
}, skip: [:registrations]
  # Ruta raíz
  root "storefront#index" # Página principal para el storefront público

  # Administración (requiere autenticación y roles)
    namespace :admin do
      resources :products
      resources :sales
      resources :users
    end


  # Storefront (vista pública)
  resources :storefront, only: [:index]

  # Rutas principales para productos y ventas
  resources :products
  resources :sales do
    member do
      post :cancel
    end
  end
  
  # Administración (requiere autenticación y roles)
  namespace :admin do
    resources :products do
      member do
        delete 'delete_image/:image_id', to: 'products#delete_image', as: 'delete_product_image'
      end
    end
    resources :sales
    resources :users, except: [:destroy] do
      member do
        post :toggle_active
        patch :update
        get :edit_profile
        patch :update_profile
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