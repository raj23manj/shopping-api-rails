RSpec.describe 'Cart API', type: :request do
  let!(:product) { create(:product) }
  before { @cart_service = Api::V1::Service::CartService.new  } 
  
  describe 'POST /api/v1/carts' do
    # valid payload
    let(:valid_attributes) { { "cart" => {"is_new" => "true", 
                                        "cart_detail" => {"product_id" => product.id, "qty" => "5"} } } }

    context 'when the request is valid' do
      before { post '/api/v1/carts', params: valid_attributes }

      it 'creates a cart' do
        allow(@cart_service).to receive(:create_cart).and_return({
                                                                    "data": {
                                                                        "id": 14,
                                                                        "active": true
                                                                    }
                                                                })
        expect(json["data"]["active"]).to eq(true)
      end

      it 'returns status code 201' do
        allow(@cart_service).to receive(:create_cart).and_return({
                                                                    "data": {
                                                                        "id": 14,
                                                                        "active": true
                                                                    }
                                                                })
        
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/carts', params: { "cart" => {"is_new" => "true", 
                                                  "cart_detail" => {"product_id" => nil, "qty" => "5"} } } }
    
      it 'returns status code 422' do
        allow(@cart_service).to receive(:create_cart).and_return({
                                                                    "message": "Validation failed: Product must exist, Product can't be blank"
                                                                })
        expect(response).to have_http_status(422)
      end
    
      it 'returns a validation failure message' do
        allow(@cart_service).to receive(:create_cart).and_return({
                                                                  "message": "Validation failed: Product must exist, Product can't be blank"
                                                                })
        
        expect(json["message"])
          .to match("Validation failed: Product must exist, Product can't be blank")
      end
    end
  end
end  