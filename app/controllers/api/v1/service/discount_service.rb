module Api
  module V1
    module Service  
      class DiscountService
        attr_reader :product_discount_rules, :total_discount_rules
        
        def initialize
          @product_discount_rules = DiscountRule.all.to_a
          @total_discount_rules = TotalDiscountRule.all.to_a 
        end
        
        def calculate_discount(cart_items)
          data = discount_on_products(cart_items)
          data.merge( discount_on_total(data[:total_price]) )
        end
        
        def discount_on_products(cart_items)
          items_with_discount = []
          total_price = 0
          cart_items.each do |item|
            # get the rule suitable for current discount
            p_discount_rule = (product_discount_rules.select {|rule| (item.p_id == rule.product_id) && (item.c_qty >= rule.qty) })
                              .sort {|a,b| a.qty <=> b.qty }.first
            # calculate discount
            calculate_discount = calculate_actual_discount(p_discount_rule, item.c_qty, item.p_price) unless p_discount_rule.blank?
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
        
        def discount_on_total(total)
          t_discount_rule = (total_discount_rules.select {|rule| total >= rule.total}).sort {|a,b| a.total <=> b.total }.first
          if (t_discount_rule.present? && (total >= t_discount_rule.total) )
            { discounted_total: (total - t_discount_rule.additional_discount), additional_discount: t_discount_rule.additional_discount}
          else
            { discounted_total: 0, additional_discount: 0}
          end    
        end  
        
        def calculate_actual_discount(rule, qty, actual_price)
          #3 => 75, 5, 10
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
        
      end # class End 
    end 
  end 
end            