RSpec.describe 'CartDetail API', type: :request do
  let!(:product) { create(:product) }
  let!(:cart) { create(:cart) }
  before { @cart_service = Api::V1::Service::CartService.new  } 
  
  describe 'POST /api/v1/carts/cart.id/cart_details' do
    # valid payload
    let(:valid_attributes) { { "cart_detail": {"product_id": product.id, "qty": "41", "cart_id": cart.id} } }

    context 'when the request is valid' do
      before { post "/api/v1/carts/#{cart.id}/cart_details", params: valid_attributes }

      it 'creates a cart' do
        allow(@cart_service).to receive(:update_or_create_cart_detail).and_return([{
                                                                                    "data": {
                                                                                        "id": 11,
                                                                                        "qty": 41,
                                                                                        "product_id": product.id,
                                                                                        "cart_id": cart.id,
                                                                                        "actual_price": null,
                                                                                        "discounted_price": null
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
                                                                      "cart_id": cart.id,
                                                                      "actual_price": null,
                                                                      "discounted_price": null
                                                                  }
                                                              })
        
        expect(response).to have_http_status(201)
      end
    end

    # context 'when the request is invalid' do
    #   before { post "/api/v1/carts/#{cart.id}/cart_details", params: { "cart_detail": {"product_id": nil, "qty": "41", "cart_id": cart.id} } }
    # 
    #   it 'returns status code 422' do
    #     allow(@cart_service).to receive(:update_or_create_cart_detail).and_return({
    #                                                                                 "message": "Validation failed: Product must exist, Product can't be blank"
    #                                                                               })
    #     expect(response).to have_http_status(200)
    #   end
    # 
    #   it 'returns a validation failure message' do
    #     allow(@cart_service).to receive(:update_or_create_cart_detail).and_return({
    #                                                               "message": "Validation failed: Product must exist, Product can't be blank"
    #                                                             })
    # 
    #     expect(json["message"])
    #       .to match("Validation failed: Product must exist, Product can't be blank")
    #   end
    # end
  end
end  