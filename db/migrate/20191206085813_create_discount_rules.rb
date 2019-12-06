class CreateDiscountRules < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_rules do |t|
      t.references :product, foreign_key: true
      t.boolean :active
      t.integer :qty
      t.integer :discount_price
      t.integer :discount_percentage
      t.timestamps
    end
  end
end
