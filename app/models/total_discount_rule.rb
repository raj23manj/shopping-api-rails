class TotalDiscountRule < ApplicationRecord
  default_scope { where("active = true") }
end
