FactoryBot.define do
  factory :cart_detail do
    product_id { nil }
    cart_id { nil }
    qty { nil }
    active { true }
  end
end