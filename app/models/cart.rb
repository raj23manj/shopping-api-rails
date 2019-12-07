class Cart < ApplicationRecord
  has_many :cart_details, dependent: :destroy
  
  validates_presence_of :user_id
end
