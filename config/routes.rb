Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

   # Sesiones
   get "/login", to: "sessions#new"
   post "/login", to: "sessions#create"
   delete "/logout", to: "sessions#destroy"

   # Administración (requiere autenticación)
   namespace :admin do
     resources :products
     resources :sales
     resources :users
   end

   # Rutas para otras entidades
   resources :roles
   resources :categories

   # Productos y sus imágenes (subrecursos para productos)
   resources :products do
     resources :images, only: [ :create, :destroy ] # Solo acciones necesarias para imágenes
   end

   # Health check endpoint (útil para monitoreo)
   get "up" => "rails/health#show", as: :rails_health_check
 end
