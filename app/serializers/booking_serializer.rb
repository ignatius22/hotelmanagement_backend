class BookingSerializer
  include JSONAPI::Serializer
  attributes :id, :start_date, :end_date, :created_at, :updated_at, :total_price, :num_nights, :num_guests, :status
  belongs_to :cabin
  belongs_to :user
end