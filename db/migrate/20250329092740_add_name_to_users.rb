class AddNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :full_name, :string
  end
end
