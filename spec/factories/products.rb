FactoryBot.define do
  factory :product do
    name { Faker::Name.unique.name }
    price { Faker::Number.number(digits: 2) }
    active { true }
  end
end