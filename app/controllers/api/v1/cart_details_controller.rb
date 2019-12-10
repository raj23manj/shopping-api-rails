
module Api
  module V1
    class CartDetailsController < ApplicationController
      before_action :set_cart_service, only: [:create, :count, :calculated_cart_details]
      
      def count
        data = @cart_service.current_cart_count(params[:cart_id])
        json_response(data, :ok)
      end  
      
      #http://localhost:3000/api/v1/carts/10/cart_details
      #{
      #   "cart_detail": {"product_id": "19", "qty": null, "cart_id": "10"} 
      # }
      def create
        data = @cart_service.update_or_create_cart_detail(cart_detail_params) 
        json_response(CartDetailSerializer.new(data).as_json, :created)
      end
      
      #Calulations For Discounrs
      def calculated_cart_details
        data = @cart_service.discounted_cart(params[:cart_id])
        json_response(data, :ok)
      end  
      
      private

      def cart_detail_params
        params.require(:cart_detail).permit(:qty, :product_id, :cart_id)
      end
      
      def set_cart_service
        @cart_service = Service::CartService.new()
      end  
      
    end
  end  
end    

