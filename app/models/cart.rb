class Cart < ApplicationRecord
  has_many :cart_details, dependent: :destroy
end
