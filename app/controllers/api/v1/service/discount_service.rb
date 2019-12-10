module Api
  module V1
    module Service  
      class DiscountService
        attr_reader :product_discount_service, :total_discount_service
        
        def initialize()
          @product_discount_service = Service::ProductDiscountService.new(get_product_discount_rules)
          @total_discount_service = Service::TotalDiscountService.new(get_total_discount_rules)                                            
        end
        
        def calculate_discount(cart_items)
          data = product_discount_service.discount_on_products(cart_items)
          data.merge(total_discount_service.discount_on_total(data[:total_price]))
        end 
        
        private
        
        def get_product_discount_rules 
          DiscountRule.all.to_a
        end  
        
        def get_total_discount_rules
          TotalDiscountRule.all.to_a
        end  
        
      end # class End 
    end 
  end 
end            