
module Api
  module V1
    class CartDetailsController < ApplicationController
      before_action :set_cart_service, only: [:create]
      #http://localhost:3000/api/v1/carts/10/cart_details
      #{
      #   "cart": {"is_new": "true", "cart_detail": {"product_id": "19", "qty": "5"} }
      # }
      def create
        @cart_service.update_or_create_cart_detail(cart_detail_params) 
        json_response("Sucess", :created)
      end
      
      private

      def cart_detail_params
        params.require(:cart_detail).permit(:qty, :product_id, :cart_id)
      end
      
      def set_cart_service
        @cart_service = Service::CartService.new
      end  
      
    end
  end  
end    

