RSpec.describe 'CartDetail API', type: :request do 
  let!(:product) { create(:product) }
  let!(:cart) { create(:cart) }
  before do 
    @discount_service = Api::V1::Service::DiscountService.new() 
    @cart_service = Api::V1::Service::CartService.new(@discount_service)    
  end 
   
  describe 'POST /api/v1/carts/cart.id/cart_details' do
    # valid payload
    let(:valid_attributes) { { "cart_detail": {"product_id": product.id, "qty": "41", "cart_id": cart.id} } }

    context 'when the request is valid' do
      before { post "/api/v1/carts/#{cart.id}/cart_details", params: valid_attributes }

      it 'creates a cart detail' do
        allow(@cart_service).to receive(:update_or_create_cart_detail).and_return([{
                                                                                    "data": {
                                                                                        "id": 11,
                                                                                        "qty": 41,
                                                                                        "product_id": product.id,
                                                                                        "cart_id": cart.id
                                                                                     }
                                                                                }])
        expect(json["data"]["qty"]).to eq(41)
      end

      it 'returns status code 201' do
        allow(@cart_service).to receive(:update_or_create_cart_detail).and_return({
                                                                  "data": {
                                                                      "id": 11,
                                                                      "qty": 41,
                                                                      "product_id": product.id,
                                                                      "cart_id": cart.id
                                                                  }
                                                              })
        
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/api/v1/carts/#{cart.id}/cart_details", params: { "cart_detail": {"product_id": nil, "qty": "41", "cart_id": cart.id} } }
    
      it 'returns status code 422' do
        allow(@cart_service).to receive(:update_or_create_cart_detail).and_return({
                                                                                    "message": "Validation failed: Product must exist, Product can't be blank"
                                                                                  })
        expect(response).to have_http_status(422)
      end
    
      it 'returns a validation failure message' do
        allow(@cart_service).to receive(:update_or_create_cart_detail).and_return({
                                                                                    "message": "Validation failed: Product must exist, Product can't be blank"
                                                                                  })
    
        expect(json["message"])
          .to match("Validation failed: Product must exist, Product can't be blank")
      end
    end
  end
  
  describe 'GET /api/v1/carts/:cart_id/cart_details/count' do  
    before { get "/api/v1/carts/#{99}/cart_details/count" }  
    
    it 'returns a validation failure message' do
  
      expect(json["data"]).to eq(0)
    end
    
  end
  
  describe 'GET /api/v1/carts/:cart_id/cart_details/calculated_cart_details' do 
    before { get "/api/v1/carts/#{cart.id}/cart_details/calculated_cart_details" } 
    
    context 'when the record exists' do
      it 'returns status code 200' do
        allow(@cart_service).to receive(:discounted_cart).and_return({
                                                                        "data": {
                                                                            "calculated_cart_details": [
                                                                                {
                                                                                    "cart_id": 4,
                                                                                    "cart_qty": 3,
                                                                                    "product_name": "A",
                                                                                    "actual_product_price": 30,
                                                                                    "actual_total": 90,
                                                                                    "discounted_total": 75,
                                                                                    "actual_discount_price": 75,
                                                                                    "actual_discount_qty": 3
                                                                                },
                                                                                {
                                                                                    "cart_id": 4,
                                                                                    "cart_qty": 1,
                                                                                    "product_name": "C",
                                                                                    "actual_product_price": 50,
                                                                                    "actual_total": 50,
                                                                                    "discounted_total": 0,
                                                                                    "actual_discount_price": 0,
                                                                                    "actual_discount_qty": 0
                                                                                },
                                                                                {
                                                                                    "cart_id": 4,
                                                                                    "cart_qty": 1,
                                                                                    "product_name": "D",
                                                                                    "actual_product_price": 15,
                                                                                    "actual_total": 15,
                                                                                    "discounted_total": 0,
                                                                                    "actual_discount_price": 0,
                                                                                    "actual_discount_qty": 0
                                                                                }
                                                                            ],
                                                                            "total_price": 140,
                                                                            "discounted_total": 0,
                                                                            "additional_discount": 0
                                                                        }
                                                                    })
          
        expect(response).to have_http_status(200)
      end
    end  
  end  
  
end  