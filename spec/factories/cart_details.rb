FactoryBot.define do
  factory :cart_detail do
    product_id { nil }
    cart_id { nil }
    qty { nil }
    actual_price { nil }
    discounted_price { nil }
    active { true }
  end
end