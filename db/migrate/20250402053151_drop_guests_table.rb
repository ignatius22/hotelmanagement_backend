class DropGuestsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :guests
  end
end
