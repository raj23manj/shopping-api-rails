class CartDetailSerializer < ActiveModel::Serializer
  attributes :id, :qty, :product_id, :cart_id, :actual_price, :discounted_price
end
