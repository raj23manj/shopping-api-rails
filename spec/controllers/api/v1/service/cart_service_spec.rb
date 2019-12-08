RSpec.describe Api::V1::Service::CartService, type: :service do
  let!(:cart) { create(:cart) }
  let!(:product) { create(:product) }
  let!(:product2) { create(:product) }
  
  before { @cart_service = Api::V1::Service::CartService.new  } 
  
  describe 'create_cart method' do
    context 'Successful Creation' do 
      it "run successfully" do
        new_cart = @cart_service.create_cart({"product_id": product.id, "qty": "5"})
        expect(new_cart.user_id).to eq(1)
      end
    end 
    
    context 'Failure Creation' do 
      it "throws an error" do
        expect{@cart_service.create_cart({"product_id": product.id, 
                   "qty": nil})}.to raise_error(ActiveRecord::RecordInvalid)
      end
    end 
     
  end
  
  describe 'update_or_create_cart_detail' do
    context 'Successful Creation' do
      it "run successfully to create as first enrty" do
        new_cart = @cart_service.update_or_create_cart_detail({"product_id": product.id, 
                                                              "qty": "25", 
                                                              "cart_id": cart.id})
        expect(new_cart.qty).to eq(25)
      end
      
      it "run successfully to update an existing entry" do
        @cart_service.update_or_create_cart_detail({"product_id": product2.id, 
                                                              "qty": "25", 
                                                              "cart_id": cart.id})
        
        new_cart = @cart_service.update_or_create_cart_detail({"product_id": product2.id, 
                                                              "qty": "40", 
                                                              "cart_id": cart.id})
        expect(new_cart.qty).to eq(40)
      end
    end
    
    context 'Failure Creation' do 
      it "throws an error" do
        expect{@cart_service.update_or_create_cart_detail({"product_id": nil, 
                                                              "qty": "25", 
                                                              "cart_id": cart.id})}.to raise_error(ActiveRecord::RecordInvalid)
      end
    end 
    
  end
end
