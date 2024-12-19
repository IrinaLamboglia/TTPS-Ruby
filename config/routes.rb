Rails.application.routes.draw do

  devise_for :users, controllers: {
  sessions: "users/sessions"
}, skip: [ :registrations ]
  # Ruta raíz
  root "storefront#index" # Main page for the public storefront

    # Administration (requires authentication and roles)
    namespace :admin do
      resources :products
      resources :users
    end


  # Storefront (public view)
  resources :storefront, only: [ :index ]

  resources :products
  resources :sales do
    member do
      post :cancel
    end
  end

  # Administration (requires authentication and roles)
  namespace :admin do
    resources :products do
      member do
        delete "delete_image/:image_id", to: "products#delete_image", as: "delete_product_image"
      end
    end
    resources :users, except: [ :destroy ] do
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

  # Routes for roles and categories (optional)
  resources :roles, only: [ :index, :show ]
  resources :categories, only: [ :index, :show ]

  # Subresources for images (linked to products)
  resources :products do
    resources :images, only: [ :create, :destroy ]
  end

  # Endpoint de monitoreo de salud
  get "up", to: "rails/health#show", as: :rails_health_check

  devise_scope :user do
    get "/login_as_admin", to: "sessions#login_as_admin" if Rails.env.development?
  end
end
