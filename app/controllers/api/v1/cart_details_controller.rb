
module Api
  module V1
    class CartDetailsController < ApplicationController
      before_action :set_cart_service, only: [:create, :count, :calculated_cart_details]
      
      def count
        data = @cart_service.current_cart_count(params[:cart_id])
        json_response(data, :ok)
      end  
      
      def create
        data = @cart_service.update_or_create_cart_detail(cart_detail_params) 
        json_response(CartDetailSerializer.new(data).as_json, :created)
      end
      
      #Calulations For Discounts
      def calculated_cart_details
        data = @cart_service.discounted_cart(params[:cart_id])
        json_response(data, :ok)
      end  
      
      private

      def cart_detail_params
        params.require(:cart_detail).permit(:qty, :product_id, :cart_id)
      end
      
      def set_cart_service
        # similar to Checkout.new(rules) of pseudo code
        discount_service = Service::DiscountService.new(DiscountRule.all.to_a, 
                                                        TotalDiscountRule.all.to_a)
        @cart_service = Service::CartService.new(discount_service)
      end  
      
    end
  end  
end    

