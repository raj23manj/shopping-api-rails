module Api
  module V1
    module Service  
      class TotalDiscountService
        attr_reader :rules
        
        def initialize(rules)
          @rules = rules
        end 
        
        def discount_on_total(total)
          t_discount_rule = (rules.select {|rule| rule.total <= total }).sort {|a,b| b.total <=> a.total }.first
          if (t_discount_rule.present? && (total >= t_discount_rule.total) )
            { discounted_total: (total - t_discount_rule.additional_discount), additional_discount: t_discount_rule.additional_discount}
          else
            { discounted_total: 0, additional_discount: 0}
          end    
        end  
        
      end
    end 
  end     
end        