module Api
  module V1
    class CartsController < ApplicationController
      before_action :set_cart_service, only: [:create]
      before_action :set_cart, only: [:update]
      #http://localhost:3000/api/v1/carts
      # {
      #   "cart": {"is_new": "true", "cart_detail": {"product_id": "19", "qty": "5"} }
      # }
      def create
        cart = @cart_service.create_cart(cart_params[:cart_detail]) if cart_params[:is_new] == "true"
        json_response(CartSerializer.new(cart).as_json, :created)
      end
      
      def update
        @cart.update(active: false) if cart_params[:de_activate] == "true"
        head :no_content
      end
      
      def cart_is_active
        # assuming default user as 1 , cart_params[:user_id]
        cart = Cart.where("active = true and user_id = 1")
        json_response(CartSerializer.new(cart.first).as_json, :created)
      end  
      
      private

      def cart_params
        params.require(:cart).permit(:de_activate, :user_id, :is_new, 
                                     cart_detail: [:product_id, :qty])
      end
      
      def set_cart_service
        @cart_service = Service::CartService.new
      end  
      
      def set_cart
        @cart = Cart.where("active = true and id = ?", params[:id])
      end
      
    end
  end  
end    
