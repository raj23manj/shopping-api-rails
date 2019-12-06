class Product < ApplicationRecord
  # model association
  has_many :discount_rules, dependent: :destroy

  # validations
  validates_presence_of :name, :price
end
