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
            p_discount_rules = (rules.select {|rule| (item.p_id == rule.product_id) && (rule.qty <= item.c_qty) })
                              .sort {|a,b| a.qty <=> b.qty }         
            # calculate discount
            calculate_discount = if(p_discount_rules.present?)
                                    best_discount = calculate_best_discount(p_discount_rules, item.c_qty, item.p_price)
                                 else
                                    0
                                 end    
            
            actual_price = (item.c_qty * item.p_price)
            items_with_discount << create_discounted_product(item, actual_price, calculate_discount)            
            if(p_discount_rules.present?)
              total_price += calculate_discount #add discounted price
            else
              total_price += actual_price # add actual price
            end     
          end 

          { calculated_cart_details: items_with_discount, total_price: total_price } 
        end 
        
        def calculate_best_discount(rules, item_qty, item_price)        
          min_calculated_total = 0
          
          rules.each do |rule| 
            obj = calculate_actual_discount(rule, item_qty)
            
            if(obj[:remaninig_qty] != 0)
              reamining_rules = rules.select {|rule| (rule.qty <= obj[:remaninig_qty]) }
              total = calculate_discount_remianing(rules, obj[:remaninig_qty], item_price, obj[:price]) 
              min_calculated_total = total if (total < min_calculated_total) || (min_calculated_total == 0)
            end  
            
            if(obj[:remaninig_qty] == 0) || (min_calculated_total == 0)
              min_calculated_total = obj[:price]
            end  
          end
          
          min_calculated_total
        end
        
        
        def calculate_discount_remianing(rules, item_qty, item_price, current_total)
          min_discount_rule = rules.first
          total_discount = 0
        
          while(item_qty >= min_discount_rule.qty) do
            all_rule_discounted = []
            rules.each do |rule| 
              all_rule_discounted << calculate_actual_discount(rule, item_qty)
            end
                
            best_rule_discount = best_total_discount(all_rule_discounted, current_total)
            current_total = best_rule_discount[:total]
            item_qty = best_rule_discount[:remaninig_qty] 
            rules = rules.select {|rule| (rule.qty <= item_qty) }  
          end
          current_total + (item_qty * item_price)
        end
        
        def best_total_discount(arr, prev_total)
          min_total = {remaninig_qty: 0, total: 0}
          zero_qty = {remaninig_qty: 0, total: 0}
          arr.each do |obj|
            # if 0 qty give preference
            if((obj[:remaninig_qty] == 0) &&
               ( zero_qty[:total] == 0|| obj[:price] < zero_qty[:total]))
              zero_qty[:total] = obj[:price]
              zero_qty[:remaninig_qty] = obj[:remaninig_qty]
            end  
            # find the min total
            if(min_total[:total] == 0) || (obj[:price] < min_total[:total])
              min_total[:total] = obj[:price]
              min_total[:remaninig_qty] = obj[:remaninig_qty]
            end   
          end 
        
          if(zero_qty[:total] == 0)
            min_total[:total] = min_total[:total] + prev_total
          else
            min_total[:total] = zero_qty[:total] + prev_total
            min_total[:remaninig_qty] = zero_qty[:remaninig_qty]
          end 
        
          min_total   
        end    
        
        def calculate_actual_discount(rule, qty)
          discounted_qty = ((qty/rule.qty).to_s.split(".").first).to_i
          discounted_price = (rule.discount_price * discounted_qty ) #+ (actual_price * (qty - (discounted_qty * rule.qty)))
          remaninig_qty = qty - (discounted_qty * rule.qty)
          {price: discounted_price, remaninig_qty: remaninig_qty}
        end   
        
        def create_discounted_product(item, actual_price, calculate_discount)
          OpenStruct.new(cart_id: item.c_cart_id,
                                                cart_qty: item.c_qty,
                                                product_name: item.p_name,
                                                actual_product_price: item.p_price,
                                                actual_total: actual_price,
                                                discounted_total: ((calculate_discount == 0) ? 0 : calculate_discount)
                                              ).marshal_dump
        end   
        
      end # class end
    end
  end        
end        