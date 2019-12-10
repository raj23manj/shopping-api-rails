RSpec.describe Api::V1::Service::DiscountService, type: :service do
  # total discount rule
  let!(:total_discount_rule) { create(:total_discount_rule, total: 150, additional_discount: 20) }
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
  before do
    @cart_service = Api::V1::Service::CartService.new() 
    @discount_service = Api::V1::Service::DiscountService.new(DiscountRule.all.to_a, TotalDiscountRule.all.to_a) 
  end
  
  after(:all) do
    CartDetail.delete_all
  end
  
  describe "discount_on_products method" do
    context "Return expected Result" do
      before do
        @cart_detail1 = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 1) 
        @cart_detail2 = create(:cart_detail, product_id: product2.id, cart_id: cart.id, qty: 1) 
        @cart_detail3 = create(:cart_detail, product_id: product3.id, cart_id: cart.id, qty: 1)
        @items = @cart_service.cart_detail_with_product(cart.id)
  
        @response = @discount_service.discount_on_products(@items)  
      end
  
      it "run total_price" do
        expect(@response[:total_price]).to eq(100)
      end
    end
  end
  
  describe "calculate_actual_discount method" do
    context "Return expected Result" do
      before do
        @response = @discount_service.calculate_actual_discount(discount_rule1, 5, 30)  
      end
  
      it "run total_price" do
        expect(@response).to eq(135)
      end
    end
  end
  
  describe "discount_on_total method" do
    context "Return expected Result with discount" do
      before do
        @response = @discount_service.discount_on_total(175)  
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(155)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(20)
      end
    end
  
    context "Return expected Result without discount" do
      before do
        @response = @discount_service.discount_on_total(140)  
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(0)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(0)
      end
    end
  end
  
  describe 'Test Case 1' do
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
  end  # describe end 
  
  describe 'Test Case 2' do
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
  end
  
  describe 'Test Case 3' do
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
  end 
  
  describe 'Test Case 4' do
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
  end 
  
  describe 'Test Case 5' do
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
  end 
  
  describe 'Test Case 6' do
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
  end 
  
end  