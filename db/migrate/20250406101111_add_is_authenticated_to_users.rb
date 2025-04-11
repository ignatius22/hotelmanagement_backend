class AddIsAuthenticatedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_authenticated, :boolean, default: false, null: false
  end
end
