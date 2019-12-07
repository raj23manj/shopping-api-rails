require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should have_many(:discount_rules).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
end
