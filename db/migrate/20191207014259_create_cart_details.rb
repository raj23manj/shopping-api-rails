class CreateCartDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_details do |t|
      t.references :product, foreign_key: true
      t.references :cart, foreign_key: true
      t.integer :qty
      t.timestamps
    end
  end
end
