Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      
      resources :products
      
      resources :carts, only: [:show, :create, :update] do
        resources :cart_details, only: [:index, :create]
      end
      
    end
  end  
end
