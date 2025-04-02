class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.date :start_date
      t.date :end_date
      t.integer :num_nights
      t.integer :num_guests
      t.decimal :cabin_price
      t.decimal :extras_price
      t.decimal :total_price
      t.boolean :has_breakfast
      t.text :observations
      t.boolean :is_paid
      t.references :guest, null: false, foreign_key: true
      t.references :cabin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
