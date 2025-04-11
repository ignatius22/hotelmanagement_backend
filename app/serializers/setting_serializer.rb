class SettingSerializer
  include JSONAPI::Serializer

  attributes :id, :min_booking_length, :max_booking_length, :max_guests_per_booking, :breakfast_price, :created_at, :updated_at
end