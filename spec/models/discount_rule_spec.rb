require 'rails_helper'

RSpec.describe DiscountRule, type: :model do
  # Association test
  it { should belong_to(:product) }
  
end
