require 'rails_helper'

RSpec.describe Api::V1::Service::TotalDiscountService, type: :service do  
  describe "discount_on_total method" do
    
    before do
      # total discount rule
      @total_discount_rule = create(:total_discount_rule, total: 150, additional_discount: 20) 
      @total_discount_service = Api::V1::Service::TotalDiscountService.new(TotalDiscountRule.all.to_a)
    end
    
    context "Return expected Result with discount" do
      before do
        @response = @total_discount_service.discount_on_total(175)  
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
        @response = @total_discount_service.discount_on_total(140)  
      end
  
      it "run discounted_total" do
        expect(@response[:discounted_total]).to eq(0)
      end
  
      it "run additional_discount" do
        expect(@response[:additional_discount]).to eq(0)
      end
    end
  end
end  