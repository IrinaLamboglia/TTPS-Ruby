Rails.application.routes.draw do

  devise_for :users
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
  resources :sales

  
  # Rutas para roles y categorías (opcional)
  resources :roles, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # Subrecursos para imágenes (vinculadas a productos)
  resources :products do
    resources :images, only: [:create, :destroy]
  end

  # Endpoint de monitoreo de salud
  get "up", to: "rails/health#show", as: :rails_health_check
end