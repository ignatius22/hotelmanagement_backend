class CabinSerializer
  include JSONAPI::Serializer

  attributes :id, :max_capacity, :regular_price, :discount, :final_price, :created_at, :updated_at, :name

  has_many :bookings

  attribute :final_price do |object|
    object.final_price # Ensure this method or column exists in Cabin model
  end
end