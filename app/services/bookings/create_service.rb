module Bookings
  class CreateService
    def initialize(cabin, params)
      @cabin = cabin
      @params = params
    end

    def call
      booking = @cabin.bookings.new(@params)

      if booking.save
        OpenStruct.new(success?: true, booking: booking)
      else
        OpenStruct.new(success?: false, errors: booking.errors.full_messages)
      end
    end
  end
end