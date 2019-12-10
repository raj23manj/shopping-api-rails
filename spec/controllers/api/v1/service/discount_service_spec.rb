RSpec.describe Api::V1::Service::DiscountService, type: :service do

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
  
  describe 'Test Cases with one rule per product' do
    before do
      # total discount rule
      @total_discount_rule = create(:total_discount_rule, total: 150, additional_discount: 20) 
      # Product Discount Rule
      @discount_rule1 = create(:discount_rule, product_id: product1.id, qty: 3, discount_price: 75)  # "A"
      @discount_rule2 = create(:discount_rule, product_id: product2.id, qty: 2, discount_price: 35)  # "B"
      # Services
      @discount_service = Api::V1::Service::DiscountService.new()
      @cart_service = Api::V1::Service::CartService.new(@discount_service) 
    end
    
    context "A,B,C => Rs. 100" do
      before do
        @cart_detail1 = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 1) 
        @cart_detail2 = create(:cart_detail, product_id: product2.id, cart_id: cart.id, qty: 1) 
        @cart_detail3 = create(:cart_detail, product_id: product3.id, cart_id: cart.id, qty: 1) 
        @response = @cart_service.discounted_cart(cart.id)
      end
  
      it "run total_price" do
        expect(@response[:total_price]).to eq(100)
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(0)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(0)
      end
  
      it "run calculated_cart_details" do
        expect(@response[:calculated_cart_details].size).to eq(3)
      end
    end
    
    context " B, A, B, A, A => Rs. 110" do
      before do
        @cart_detail1 = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 3) 
        @cart_detail2 = create(:cart_detail, product_id: product2.id, cart_id: cart.id, qty: 2) 
        @response = @cart_service.discounted_cart(cart.id)
      end
  
      it "run total_price" do
        expect(@response[:total_price]).to eq(110)
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(0)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(0)
      end
  
      it "run calculated_cart_details" do
        expect(@response[:calculated_cart_details].size).to eq(2)
      end
    end
    
    context " C, B, A, A, D, A, B => Rs. 155" do
      before do
        @cart_detail1 = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 3) 
        @cart_detail2 = create(:cart_detail, product_id: product2.id, cart_id: cart.id, qty: 2)
        @cart_detail3 = create(:cart_detail, product_id: product3.id, cart_id: cart.id, qty: 1)
        @cart_detail4 = create(:cart_detail, product_id: product4.id, cart_id: cart.id, qty: 1) 
        @response = @cart_service.discounted_cart(cart.id)
      end
  
      it "run total_price" do
        expect(@response[:total_price]).to eq(175)
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(155)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(20)
      end
  
      it "run calculated_cart_details" do
        expect(@response[:calculated_cart_details].size).to eq(4)
      end
    end
    
    context " C, A, D, A , A => Rs. 140" do
      before do
        @cart_detail1 = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 3) 
        @cart_detail2 = create(:cart_detail, product_id: product3.id, cart_id: cart.id, qty: 1)
        @cart_detail3 = create(:cart_detail, product_id: product4.id, cart_id: cart.id, qty: 1) 
        @response = @cart_service.discounted_cart(cart.id)
      end
  
      it "run total_price" do
        expect(@response[:total_price]).to eq(140)
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(0)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(0)
      end
  
      it "run calculated_cart_details" do
        expect(@response[:calculated_cart_details].size).to eq(3)
      end
    end
    
    context "A, A, A, A, A, A => Rs. 130" do
      before do
        @cart_detail1 = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 6) 
        @response = @cart_service.discounted_cart(cart.id)
      end
  
      it "run total_price" do
        expect(@response[:total_price]).to eq(150)
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(130)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(20)
      end
  
      it "run calculated_cart_details" do
        expect(@response[:calculated_cart_details].size).to eq(1)
      end
    end
    
    context " 5A, 5B, 1C, 1D => Rs. 270" do
      before do
        @cart_detail1 = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 5)
        @cart_detail2 = create(:cart_detail, product_id: product2.id, cart_id: cart.id, qty: 5)
        @cart_detail3 = create(:cart_detail, product_id: product3.id, cart_id: cart.id, qty: 1)
        @cart_detail4 = create(:cart_detail, product_id: product4.id, cart_id: cart.id, qty: 1)  
        @response = @cart_service.discounted_cart(cart.id)
      end
  
      it "run total_price" do
        expect(@response[:total_price]).to eq(290)
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(270)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(20)
      end
  
      it "run calculated_cart_details" do
        expect(@response[:calculated_cart_details].size).to eq(4)
      end
    end
    
  end  # describe end 
end # end 