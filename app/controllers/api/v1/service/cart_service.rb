module Api
  module V1
    module Service
      
      class CartService
        def create_cart_detail(cartDetail, cart_id)
          #byebug
          CartDetail.create!({ product_id: cartDetail[:product_id], 
                               qty: cartDetail[:qty],
                               cart_id: cart_id
                            })
        end  
        
        def create_cart(cartDetail, user_id=1)
          cart = nil
          ActiveRecord::Base.transaction do
            cart = Cart.create!({user_id: user_id, active: true})
            create_cart_detail(cartDetail, cart.id)
          end
          cart
        end  
      end  
      
    end 
  end 
end    



