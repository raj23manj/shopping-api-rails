FactoryBot.define do
  factory :total_discount_rule do
    total { nil }
    additional_discount { nil }
    active { true }
  end
end