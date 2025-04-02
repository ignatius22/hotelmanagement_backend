class CreateGuests < ActiveRecord::Migration[7.1]
  def change
    create_table :guests do |t|
      t.string :full_name
      t.string :email
      t.string :nationality
      t.string :country_flag
      t.string :national_id

      t.timestamps
    end
  end
end
