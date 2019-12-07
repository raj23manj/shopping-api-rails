module Api
  module V1
    class CartsController < ApplicationController
      before_action :set_cart_service, only: [:create]
      
      def create
        cart = @cart_service.create_cart(product_params[:cart_detail]) if params[:cart][:is_new] == "true"
        json_response(cart, :created)
      end
      
      private

      def product_params
        params.require(:cart).permit(:is_new, cart_detail: [:product_id, :qty])
      end
      
      def set_cart_service
        @cart_service = Service::CartService.new
      end  
    end
  end  
end    
