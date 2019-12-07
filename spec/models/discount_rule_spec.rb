require 'rails_helper'

RSpec.describe DiscountRule, type: :model do
  it { should belong_to(:product) }
end
