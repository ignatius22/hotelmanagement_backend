class AddUserIdToBookings < ActiveRecord::Migration[7.1]
  def change
    add_reference :bookings, :user, null: false, foreign_key: true
    remove_reference :bookings, :guest, foreign_key: true
  end
end
