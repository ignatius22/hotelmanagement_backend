class BookingSerializer
  include JSONAPI::Serializer
  attributes :id, :start_date, :end_date, 
             :created_at, :updated_at, :total_price, 
             :num_nights, :num_guests, :status,
             :has_breakfast, :observations,
             :extras_price,
             :cabin_price,
             :is_paid


  belongs_to :cabin
  belongs_to :user
end