class CreateCabins < ActiveRecord::Migration[7.1]
  def change
    create_table :cabins do |t|
      t.integer :max_capacity
      t.integer :regular_price
      t.integer :discount
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
