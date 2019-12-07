RSpec.describe 'Products API', type: :request do
  let!(:products) { create_list(:product, 4) }
  let(:product_id) { products.first.id }
  
  describe 'GET /api/v1/products' do
    before { get '/api/v1/products' }

    it 'returns products' do
      expect(json).not_to be_empty
      expect(json["data"].size).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /api/v1/products/:id' do
    before { get "/api/v1/products/#{product_id}" }

    context 'when the record exists' do
      it 'returns the product' do
        expect(json["data"]).not_to be_empty
        expect(json["data"]['id']).to eq(product_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when the record does not exist' do
      let(:product_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end
  
  describe 'POST /api/v1/products' do
    # valid payload
    let(:valid_attributes) { { "product" => { "name" => "C", "price" => "10"} } }

    context 'when the request is valid' do
      before { post '/api/v1/products', params: valid_attributes }

      it 'creates a product' do
        expect(json["data"]["name"]).to eq('C')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/products', params: {"product" => { "name" => "C", "price" => nil} } }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns a validation failure message' do
        expect(json["message"])
          .to match("Validation failed: Price can't be blank")
      end
    end
  end
  
  describe 'PUT /api/v1/products/:id' do
    let(:valid_attributes) { { "product" => { "name" => "C", "price" => "10"} } }

    context 'when the record exists' do
      before { put "/api/v1/products/#{product_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
  
  describe 'DELETE /api/v1/products/:id' do
    before { delete "/api/v1/products/#{product_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end #Main End 