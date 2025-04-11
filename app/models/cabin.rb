class Cabin < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :max_capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :regular_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  # Set default discount if not provided
  before_save :set_default_discount

  def final_price
    discount.present? ? regular_price * (1 - discount / 100.0) : regular_price
  end

  private

  def set_default_discount
    self.discount ||= 0
  end
end
