RSpec.describe Api::V1::Service::ProductDiscountService, type: :service do
  # Custom Products
  let!(:product1) { create(:product, name: "A", price: 30) }
  let!(:product2) { create(:product, name: "B", price: 20) }
  let!(:product3) { create(:product, name: "C", price: 50) }
  let!(:product4) { create(:product, name: "D", price: 15) }
  
  # Cart
  let!(:cart) { create(:cart) }
  
  after(:all) do
    CartDetail.delete_all
  end
  
  describe "discount_on_products method" do
    
    before do
      # Product Discount Rules
      @discount_rule1 = create(:discount_rule, product_id: product1.id, qty: 3, discount_price: 75)  # "A"
      @discount_rule2 = create(:discount_rule, product_id: product2.id, qty: 2, discount_price: 35)  # "B"
      @product_discount_service = Api::V1::Service::ProductDiscountService.new(DiscountRule.all.to_a)
      @discount_service =  Api::V1::Service::DiscountService.new()
      @cart_service = Api::V1::Service::CartService.new(@discount_service) 
    end
    
    context "Return expected Result" do
      before do
        @cart_detail1 = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 1) 
        @cart_detail2 = create(:cart_detail, product_id: product2.id, cart_id: cart.id, qty: 1) 
        @cart_detail3 = create(:cart_detail, product_id: product3.id, cart_id: cart.id, qty: 1)
        @items = @cart_service.cart_detail_with_product(cart.id)
  
        @response = @product_discount_service.discount_on_products(@items)  
      end
  
      it "run total_price" do
        expect(@response[:total_price]).to eq(100)
      end
    end

    context "Return expected Result" do
      before do
        @response = @product_discount_service.calculate_actual_discount(@discount_rule1, 5, 30)  
      end
  
      it "run total_price" do
        expect(@response).to eq(135)
      end
    end
  end
  
end  # end