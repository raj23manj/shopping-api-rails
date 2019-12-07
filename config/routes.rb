Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      resources :products
      
      resources :cart, only: [:show, :create] do
        resources :cart_details, only: [:index, :create]
      end
    end
  end  
end
