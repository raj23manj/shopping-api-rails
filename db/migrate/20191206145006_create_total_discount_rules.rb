class CreateTotalDiscountRules < ActiveRecord::Migration[5.2]
  def change
    create_table :total_discount_rules do |t|
      t.integer :total
      t.integer :additional_discount  
      t.timestamps
    end
  end
end
