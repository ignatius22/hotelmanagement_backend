class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.integer :min_booking_length
      t.integer :max_booking_length
      t.integer :max_guests_per_booking
      t.decimal :breakfast_price

      t.timestamps
    end
  end
end
