class Product < ApplicationRecord
  has_many :discount_rules, dependent: :destroy

  validates_presence_of :name, :price
end
