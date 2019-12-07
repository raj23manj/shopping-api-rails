module Api
  module V1
    module Service  
      class CartService
        
        def update_or_create_cart_detail(cart_detail)
          cart_found = find_cart_detail(cart_detail)
          if(cart_found.blank?)
            create_cart_detail(cart_detail) 
          else
            cart_found.update(qty: cart_detail[:qty])
            # if cart_detail[:qty] == 0
            #   cart_details = find_cart_with_items(cart_detail[:cart_id])
            #   if(cart_details.size == 0)
            #     cart_details.update(active: false)
            #   end  
            # end  
          end    
        end  
        
        def create_cart_detail(cart_detail)
          CartDetail.create!({ product_id: cart_detail[:product_id], 
                               qty: cart_detail[:qty],
                               cart_id: cart_detail[:cart_id]
                            })
        end  
        
        def create_cart(cart_detail, user_id=1)
          cart = nil
          ActiveRecord::Base.transaction do
            cart = Cart.create!({user_id: user_id, active: true})
            create_cart_detail(cart_detail.merge({cart_id: cart.id}))
          end
          cart
        end
        
        def find_cart_detail(cart_detail)
          CartDetail.where("cart_id = :c_id and product_id = :p_id ", 
                          { :c_id => cart_detail[:product_id], 
                            :p_id => cart_detail[:cart_id]
                          })
        end
        
        def find_cart_with_items(id)
          Cart.joins(:cart_details).where(id: id)
        end      
        
      end # class End 
    end 
  end 
end    


