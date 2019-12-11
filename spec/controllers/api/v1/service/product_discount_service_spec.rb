require 'rails_helper'

RSpec.describe Api::V1::Service::ProductDiscountService, type: :service do
  # Custom Products
  let!(:product1) { create(:product, name: "A", price: 30) }
  let!(:product2) { create(:product, name: "B", price: 20) }
  let!(:product3) { create(:product, name: "C", price: 50) }
  let!(:product4) { create(:product, name: "D", price: 15) }
  
  # Cart
  let!(:cart) { create(:cart) }
  
  before(:all) do
    CartDetail.delete_all
    DiscountRule.delete_all
  end
  
  describe "discount_on_products method with one rule per product" do
  
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
  end
  
  describe "discount_on_products method with multiple rules per product" do
    before do
      # Product Discount Rules
      @discount_rule1 = create(:discount_rule, product_id: product1.id, qty: 2, discount_price: 50)  # "A"
      @discount_rule2 = create(:discount_rule, product_id: product1.id, qty: 3, discount_price: 65)  # "A"
      @discount_rule3 = create(:discount_rule, product_id: product1.id, qty: 4, discount_price: 90)  # "A"
      
      @product_discount_service = Api::V1::Service::ProductDiscountService.new(DiscountRule.all.to_a)
  
      @discount_service =  Api::V1::Service::DiscountService.new()
      @cart_service = Api::V1::Service::CartService.new(@discount_service) 
    end
  
    context "Return expected Result" do
      before do
        @cart_detail = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 10) 
        @items = @cart_service.cart_detail_with_product(cart.id)
        @response = @product_discount_service.calculate_best_discount(DiscountRule.where("product_id = ?", product1.id).to_a, 
                                                                      @cart_detail.qty, product1.price) #30  
      end
    
      it "run total_price" do
        expect(@response).to eq(225)
      end
    end
  
    context "Return expected Result" do
      before do
        @cart_detail = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 11) 
        @items = @cart_service.cart_detail_with_product(cart.id)
        @response = @product_discount_service.calculate_best_discount(DiscountRule.where("product_id = ?", product1.id).to_a, 
                                                                      @cart_detail.qty, product1.price)  #30
      end
    
      it "run total_price" do
        expect(@response).to eq(245)
      end
    end
    
    context "Return expected Result" do
      before do
        @cart_detail = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 15) 
        @items = @cart_service.cart_detail_with_product(cart.id)
        @response = @product_discount_service.calculate_best_discount(DiscountRule.where("product_id = ?", product1.id).to_a, 
                                                                      @cart_detail.qty, product1.price)  #30
      end
    
      it "run total_price" do
        expect(@response).to eq(325)
      end
    end
    
    context "Return expected Result" do
      before do
        @cart_detail = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 7) 
        @items = @cart_service.cart_detail_with_product(cart.id)
        @response = @product_discount_service.calculate_best_discount(DiscountRule.where("product_id = ?", product1.id).to_a, 
                                                                      @cart_detail.qty, product1.price)  #30
      end
    
      it "run total_price" do
        expect(@response).to eq(155)
      end
    end
    
    context "Return expected Result" do
      before do
        @cart_detail = create(:cart_detail, product_id: product1.id, cart_id: cart.id, qty: 3) 
        @items = @cart_service.cart_detail_with_product(cart.id)
        @response = @product_discount_service.calculate_best_discount(DiscountRule.where("product_id = ?", product1.id).to_a, 
                                                                      @cart_detail.qty, product1.price)  #30
      end
    
      it "run total_price" do
        expect(@response).to eq(65)
      end
    end
  end
  
end  # end