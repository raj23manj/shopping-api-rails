FactoryBot.define do
  factory :discount_rule do
    total { nil }
    additional_discount { nil }
    active { true }
  end
end