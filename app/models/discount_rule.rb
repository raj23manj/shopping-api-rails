class DiscountRule < ApplicationRecord
  belongs_to :product
  default_scope { where("active = true") }
end
