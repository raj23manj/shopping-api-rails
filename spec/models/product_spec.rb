require 'rails_helper'

RSpec.describe Product, type: :model do
  # Association test
  it { should have_many(:discount_rules).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
end
