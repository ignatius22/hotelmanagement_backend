module Bookings
  class ManageService
    def initialize(booking = nil, params = {})
      @booking = booking || Booking.new
      @params = params
    end

    # Creates a new booking
    def create
      process_booking(:create)
    end

    # Updates an existing booking
    def update
      process_booking(:update)
    end

    private

    # Handles the booking creation or update process
    def process_booking(action)
      raise ArgumentError, "Parameters cannot be empty" if @params.empty?

      if @booking.update(@params)
        OpenStruct.new(success?: true, booking: @booking)
      else
        OpenStruct.new(success?: false, errors: @booking.errors.full_messages)
      end
    rescue StandardError => e
      OpenStruct.new(success?: false, errors: ["An error occurred during #{action}: #{e.message}"])
    end
  end
end