namespace :seed do
  desc "Create Dummy Data Discounts"
  task data_set_1: :environment do 
    
    # Delete All Data First
    CartDetail.delete_all
    Cart.delete_all
    DiscountRule.delete_all
    Product.delete_all
    TotalDiscountRule.delete_all
    
    # Create Products First
    data = [
      ["A", 30], ["B", 20], ["C", 50], ["D", 15]
    ]
    data.each { |arr| Product.create(name: arr[0], price: arr[1], active: true) }
    
    # Create Discount Rules Next
    products = ["A", "B", "C", "D"]
    discounts = {
      "A" => [3, 75],
      "B" => [2, 35]
    }
    products.each do |product| 
      obj = Product.find_by_name(product)
      discount = discounts[obj.name]
      DiscountRule.create(product_id: obj.id, 
                          active: true,
                          qty: discount[0], 
                          discount_price: discount[1]) unless discount.blank?
    end
    
    TotalDiscountRule.create(total: 150, additional_discount: 20, active: true)
  end
  
  task data_set_2: :environment do 
    
    # Delete All Data First
    CartDetail.delete_all
    Cart.delete_all
    
    DiscountRule.delete_all
    Product.delete_all
    TotalDiscountRule.delete_all
    
    
    # Create Products First
    data = [
      ["A", 30], ["B", 20], ["C", 50], ["D", 15]
    ]
    data.each { |arr| Product.create(name: arr[0], price: arr[1], active: true) }
    
    # Create Discount Rules Next
    products = ["A", "B", "C", "D"]
    discounts = {
      "A" => [[2, 50], [3, 65], [4, 90]],
      "B" => [[2, 35], [3, 45], [4, 55]]
    }
    products.each do |product| 
      obj = Product.find_by_name(product)
      discount_rules = discounts[obj.name]
      discount_rules.each do |discount|
        DiscountRule.create(product_id: obj.id, 
                            active: true,
                            qty: discount[0], 
                            discount_price: discount[1]) unless discount.blank?
      end  unless discount_rules.blank?
    end
    
    TotalDiscountRule.create(total: 150, additional_discount: 20, active: true)
  end
  
  
end