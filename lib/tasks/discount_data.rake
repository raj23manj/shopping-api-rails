namespace :discount do
  desc "Create Dummy Data Discounts"
  task data: :environment do 
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
  end
end