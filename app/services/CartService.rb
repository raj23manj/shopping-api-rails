class CartService
  
  def create_cart_detail(cartDetail, cart_id)
    CartDetail.create!({ product_id: cartDetail["product_id"], 
                         qty: cartDetail["qty"],
                         cart_id: cart_id
                      })
  end  
  
  def create_cart(cartDetail, user_id=1)
    cart = Cart.create!({user_id: user_id, active: true})
    create_cart_detail(cartDetail, cart.id)
    cart
  end  
end  