module Api
  module V1
    module Service  
      class CartService
        attr_reader :discount_service
        
        def initialize(discount_service = nil)
          @discount_service = discount_service 
        end
        
        def create_cart(cart_detail, user_id=1)
          cart = nil
          ActiveRecord::Base.transaction do
            cart = Cart.create!({user_id: user_id, active: true})
            cart_detail = create_cart_detail(cart_detail.merge({cart_id: cart.id}))
          end
          cart
        end
        
        def update_or_create_cart_detail(cart_detail)
          cart_found = find_cart_detail(cart_detail)
          if(cart_found.blank?)
            cart_found = create_cart_detail(cart_detail) 
          else
            cart_found = cart_found.update(qty: cart_detail[:qty])
            cart_found = cart_found.first
          end  
          cart_found  
        end  
        
        def discounted_cart(cart_id)
          discount_service.calculate_discount(cart_detail_with_product(cart_id))
        end
        
        def current_cart_count(cart_id)
          (CartDetail.where("cart_id = ?", cart_id).select("count(*)").to_a).first["count(*)"]
        end   
        
        def cart_detail_with_product(cart_id)
          cart_items = CartDetail.joins(:product, :cart)
                                 .where("cart_details.cart_id = ? and carts.active = true", cart_id)  
                                 .select("products.id as p_id, products.name as p_name, products.price as p_price, 
                                          cart_details.cart_id as c_cart_id, cart_details.qty as c_qty")
                                 .to_a
        end    
        
        private
        
        def create_cart_detail(cart_detail)
          CartDetail.create!({ product_id: cart_detail[:product_id], 
                               qty: cart_detail[:qty],
                               cart_id: cart_detail[:cart_id]
                            })
        end  
        
        def find_cart_detail(cart_detail)
          CartDetail.joins(:cart)
                    .where("cart_details.cart_id = :c_id and cart_details.product_id = :p_id and carts.active = true", 
                            { :c_id => cart_detail[:cart_id], 
                              :p_id => cart_detail[:product_id]
                            }
                          )
                    .select("cart_details.*")
        end
        
      end # class End 
    end 
  end 
end    



