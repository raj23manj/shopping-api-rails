Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      
      resources :products
      
      resources :carts, only: [:show, :create, :update] do
        resources :cart_details, only: [:create] do
          collection do
            get 'calculated_cart_details'
            get 'count'
          end
        end
        
        collection do
          get 'cart_is_active'
        end
      end
      
    end
  end  
end
