class CartDetail < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  
  validates_presence_of :qty, :product_id, :cart_id
end
