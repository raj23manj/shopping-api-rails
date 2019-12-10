module Api
  module V1
    module Service  
      class ProductDiscountService
        attr_reader :rules
        
        def initialize(rules)
          @rules = rules
        end  
        
        def discount_on_products(cart_items)
          items_with_discount = []
          total_price = 0
          cart_items.each do |item|
            # get the rule suitable for current discount
            # if multiple rules are there for one product get the current sutible one
            p_discount_rule = (rules.select {|rule| (item.p_id == rule.product_id) && (rule.qty <= item.c_qty) })
                              .sort {|a,b| b.qty <=> a.qty }.first
                              
            # calculate discount
            calculate_discount = p_discount_rule.present? ? calculate_actual_discount(p_discount_rule, item.c_qty, item.p_price) : 0
            actual_price = (item.c_qty * item.p_price)
            items_with_discount << create_discounted_product(item, p_discount_rule, actual_price, calculate_discount)
            
            if (p_discount_rule.present? && (item.c_qty >= p_discount_rule.qty))
              total_price += calculate_discount #add discounted price
            else
              total_price += actual_price # add actual price
            end     
          end 

          { calculated_cart_details: items_with_discount, total_price: total_price } 
        end 
        
        def calculate_actual_discount(rule, qty, actual_price)
          discounted_qty = ((qty/rule.qty).to_s.split(".").first).to_i
          (rule.discount_price * discounted_qty ) + (actual_price * (qty - (discounted_qty * rule.qty)))
        end   
        
        def create_discounted_product(item, p_discount_rule, actual_price, calculate_discount)
          OpenStruct.new(cart_id: item.c_cart_id,
                                                cart_qty: item.c_qty,
                                                product_name: item.p_name,
                                                actual_product_price: item.p_price,
                                                actual_total: actual_price,
                                                discounted_total: (p_discount_rule.blank? ? 0 : calculate_discount),
                                                actual_discount_price: (p_discount_rule.blank? ? 0 : p_discount_rule.discount_price),
                                                actual_discount_qty: (p_discount_rule.blank? ? 0 : p_discount_rule.qty)
                                              ).marshal_dump
        end   
        
      end # class end
    end
  end        
end        