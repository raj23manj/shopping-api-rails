module Api
  module V1
    class CartsController < ApplicationController
      before_action :set_cart_service, only: [:create]
      #http://localhost:3000/api/v1/carts
      # {
      #   "cart": {"is_new": "true", "cart_detail": {"product_id": "19", "qty": "5"} }
      # }
      def create
        cart = @cart_service.create_cart(cart_params[:cart_detail]) if cart_params[:is_new] == "true"
        json_response(CartSerializer.new(cart).as_json, :created)
      end
      
      private

      def cart_params
        params.require(:cart).permit(:is_new, cart_detail: [:product_id, :qty])
      end
      
      def set_cart_service
        @cart_service = Service::CartService.new
      end  
      
    end
  end  
end    
