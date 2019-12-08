class CartDetailSerializer < ActiveModel::Serializer
  attributes :id, :qty, :product_id, :cart_id
end
