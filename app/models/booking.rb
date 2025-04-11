class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :cabin

  # Validations
  validates :user, presence: true
  validates :cabin, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validate :no_overlapping_bookings

  enum status: { unconfirmed: "unconfirmed", checked_in: "checked-in", checked_out: "checked-out" }, _default: "unconfirmed"

  # Scopes
  scope :active, -> { where('end_date >= ?', Date.today) }
  scope :past, -> { where('end_date < ?', Date.today) }

  private

  # Ensure the end date is after the start date
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date <= start_date
      errors.add(:end_date, 'must be after the start date')
    end
  end

  # Ensure no overlapping bookings for the same cabin
  def no_overlapping_bookings
    return if start_date.blank? || end_date.blank?

    overlapping_bookings = Booking.where(cabin_id: cabin_id)
                                  .where.not(id: id)
                                  .where('start_date < ? AND end_date > ?', end_date, start_date)

    if overlapping_bookings.exists?
      errors.add(:base, 'This cabin is already booked for the selected dates')
    end
  end
end
