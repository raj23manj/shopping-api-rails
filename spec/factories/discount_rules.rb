FactoryBot.define do
  factory :discount_rule do
    product_id { nil }
    active { true }
    qty { nil }
    discount_price { nil }
    discount_percentage { nil }
  end
end