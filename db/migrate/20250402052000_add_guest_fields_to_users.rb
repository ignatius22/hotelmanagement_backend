class AddGuestFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nationality, :string
    add_column :users, :country_flag, :string
    add_column :users, :national_id, :string
  end
end
