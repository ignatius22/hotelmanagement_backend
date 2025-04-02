class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :cabin

  validates :user, presence: true
  validates :cabin, presence: true

end
