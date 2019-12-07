module Api
  module V1
    module Service  
      class DiscountService
        
        attr_reader :product_discount_rules, :total_discount_rules
        
        def initialize
          @product_discount_rules = DiscountRule.all.to_a
          @total_discount_rules = TotalDiscountRule.all.to_a 
        end
        
        def discount_on_products(cart_items)
          items_with_discount = []
          total_price = 0
          cart_items.each do |item|
            
          end  
          #OpenStruct.new
        end 
        
        def discount_on_total
        end  
        
        def calculate_discount(cart_items)
          discount_on_products(cart_items)
        end  
        
      end # class End 
    end 
  end 
end            