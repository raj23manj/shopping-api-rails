RSpec.describe Api::V1::Service::DiscountService, type: :service do
  # total discount rule
  let!(:total_dicsount_rule) { create(:total_dicsount_rule, total: 150, additional_discount: 20) }
  # Custom Products
  let!(:product1) { create(:product, name: "A", price: 30) }
  let!(:product2) { create(:product, name: "B", price: 20) }
  let!(:product3) { create(:product, name: "C", price: 50) }
  let!(:product4) { create(:product, name: "D", price: 15) }
  # Product Discount Rule
  let!(:discount_rule1) { create(:discount_rule, product_id: product1.id, qty: 3, discount_price: 75) } # "A"
  let!(:discount_rule2) { create(:discount_rule, product_id: product2.id, qty: 2, discount_price: 35) } # "B"
  # Cart
  let!(:cart) { create(:cart) }
  
  #before { @discount_service = Api::V1::Service::DiscountService.new }
  before { @cart_service = Api::V1::Service::CartService.new  } 
  
  describe 'A,B,C => Rs. 100' do
    before do
      let!(:cartDetail1) { create(product_id: product1.id, cart_id: cart.id, qty: 1) }
      let!(:cartDetail2) { create(product_id: product2.id, cart_id: cart.id, qty: 1) }
      let!(:cartDetail3) { create(product_id: product3.id, cart_id: cart.id, qty: 1) }
    end
    
    it "run successfully" do
      response = @cart_service.discounted_cart(cart.id)
      expect(response).to eq(1)
    end
  end  
  
end  