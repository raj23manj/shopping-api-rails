require 'rails_helper'

RSpec.describe Cart, type: :model do
    it { should have_many(:cart_details).dependent(:destroy) }
end
