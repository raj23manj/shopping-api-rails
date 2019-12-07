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
          data.merge({discounted_total: discount_on_total(data[:total_price])})
        end
        
        private
        
        def discount_on_products(cart_items)
          items_with_discount = []
          total_price = 0
          cart_items.each do |item|
            # get the rule suitable for current discount
            p_discount_rule = (product_discount_rules.select {|rule| rule.qty > item.qty}).sort {|a,b| b <=> a}.first
            # calculate discount
            calculate_discount = calculate_actual_discount(p_discount_rule, item.c_qty, item.p_price) unless p_discount_rule.blank?
            items_with_discount << OpenStruct.new(cart_id: item.c_cart_id,
                                                  cart_qty: item.c_qty,
                                                  product_name: item.p_name,
                                                  actual_product_price: item.p_price,
                                                  discounted_price: calculate_discount,
                                                  actual_discount_price: (p_discount_rule.blank? ? 0 : p_discount_rule.discount_price),
                                                  actual_discount_qty: (p_discount_rule.blank? ? 0 : p_discount_rule.qty)
                                                )
            total_price += calculate_discount
          end 
          { discounted_cart_details: items_with_discount, total_price: total_price } 
        end 
        
        def discount_on_total(total)
          t_discount_rule = (total_discount_rules.select {|rule| rule.total > total}).sort {|a,b| b <=> a}.first
        end  
        
        def calculate_actual_discount(rule, qty, actual_price)
          #3 => 75, 5, 10
          return (qty * actual_price) if rule.blank?
          total = rule.discount_price + (actual_price * (qty - rule.qty))
        end    
        
      end # class End 
    end 
  end 
end            