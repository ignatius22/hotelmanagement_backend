module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authenticate_with_jwt
      before_action :set_cabin
      before_action :set_booking, only: [:show, :update, :destroy]


      def index
        bookings = Booking.includes(:cabin, :user) # Eager load relationships
        if params[:filter_method] && params[params[:filter_method]]
          method = params[:filter_method] == 'eq' ? :where : params[:filter_method]
          bookings = bookings.send(method, params[params[:filter_method]] => params[params[:filter_method]])
        end
        bookings = bookings.order(params[:sort_by] => params[:direction] || 'asc') if params[:sort_by]

        if params[:page]
          bookings = bookings.page(params[:page]).per(params[:per_page] || 10)
          total_count = bookings.total_count
        else
           total_count = bookings.count
        end

        render json: {
          data: BookingSerializer.new(bookings, { include: [:cabin, :user] }).serializable_hash[:data],
          meta: { total_count: total_count }
        }, status: :ok
      end

      # GET /api/v1/cabins/:cabin_id/bookings/:id
      def show
        render json: BookingSerializer.new(@booking).serializable_hash.to_json, status: :ok
      end

      # POST /api/v1/cabins/:cabin_id/bookings
      def create
        result = Bookings::ManageService.new(nil, booking_params.merge(cabin: @cabin)).create
        if result.success?
          render json: BookingSerializer.new(result.booking).serializable_hash.to_json, status: :created
        else
          render json: { code: 422, message: 'Booking creation failed', errors: result.errors }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/cabins/:cabin_id/bookings/:id
      def update
        result = Bookings::ManageService.new(@booking, booking_params).update
        if result.success?
          render json: BookingSerializer.new(result.booking).serializable_hash.to_json, status: :ok
        else
          render json: { code: 422, message: 'Booking update failed', errors: result.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/cabins/:cabin_id/bookings/:id
      def destroy
        @booking.destroy
        render json: { code: 200, message: 'Booking deleted successfully' }, status: :ok
      end

      # GET /api/v1/cabins/:cabin_id/bookings/after/:date
      def after
        bookings = @cabin.bookings.where('created_at >= ? AND created_at <= ?', params[:date], Date.today.end_of_day)
        render json: {
          data: bookings.map { |b| { created_at: b.created_at, total_price: b.total_price } }
        }, status: :ok
      end

      # GET /api/v1/cabins/:cabin_id/bookings/stays/after/:date
      def stays_after
        stays = @cabin.bookings.where('start_date >= ? AND start_date <= ?', params[:date], Date.today)
        render json: {
          data: BookingSerializer.new(stays).serializable_hash[:data]
        }, status: :ok
      end

      # GET /api/v1/cabins/:cabin_id/bookings/today
      def today
        today = Date.today
        stays = @cabin.bookings.where(
          '(status = ? AND start_date = ?) OR (status = ? AND end_date = ?)',
          'unconfirmed', today, 'checked-in', today
        ).order(:created_at)
        render json: {
          data: BookingSerializer.new(stays).serializable_hash[:data]
        }, status: :ok
      end

      private


      def set_cabin
        return unless params[:cabin_id] # Only set for cabin-specific routes
        @cabin = Cabin.find_by(id: params[:cabin_id])
        render json: { code: 404, message: 'Cabin not found' }, status: :not_found unless @cabin
      end

      def set_booking
        @booking = @cabin.bookings.find_by(id: params[:id])
        render json: { code: 404, message: 'Booking not found' }, status: :not_found unless @booking
      end

      def booking_params
        params.require(:booking).permit(:start_date, :end_date, :user_id, :status, :total_price)
      end
    end
  end
end