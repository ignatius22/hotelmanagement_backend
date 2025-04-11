class AddNameToCabins < ActiveRecord::Migration[7.1]
  def change
    add_column :cabins, :name, :string, null: false, default: ""
  end
end
