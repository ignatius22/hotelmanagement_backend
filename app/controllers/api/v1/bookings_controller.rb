# app/controllers/api/v1/bookings_controller.rb
module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authenticate_with_jwt
      before_action :set_cabin, only: [:create]
      before_action :set_booking, only: [:show, :update, :destroy]

      def index
        bookings = Booking.includes(:cabin, :user)

        # Filter
        if params[:filter_field] && params[:filter_value]
          filter_method = params[:filter_method] || 'eq'
          case filter_method
          when 'eq'
            bookings = bookings.where(params[:filter_field] => params[:filter_value])
          when 'gte'
            bookings = bookings.where("#{params[:filter_field]} >= ?", params[:filter_value])
          when 'lte'
            bookings = bookings.where("#{params[:filter_field]} <= ?", params[:filter_value])
          else
            return render json: { errors: [{ detail: "Unsupported filter method: #{filter_method}" }] }, status: :bad_request
          end
        end

        # Sort
        if params[:sort_field]
          direction = params[:sort_direction] == 'desc' ? 'desc' : 'asc'
          bookings = bookings.order(params[:sort_field] => direction)
        end

        # Pagination
        per_page = params[:per_page]&.to_i || 10
        if params[:page]
          bookings = bookings.page(params[:page]).per(per_page)
          total_count = bookings.total_count
        else
          total_count = bookings.count
        end

        render json: BookingSerializer.new(
          bookings,
          meta: { total_count: total_count },
          include: ['cabin', 'user']
        ), status: :ok
      end

      def show
        if @booking
          render json: BookingSerializer.new(@booking, include: ['cabin', 'user']), status: :ok
        else
          render json: { errors: [{ detail: 'Booking not found' }] }, status: :not_found
        end
      end

      def create
        return render json: { errors: [{ detail: 'Cabin not found' }] }, status: :not_found unless @cabin

        result = Bookings::ManageService.new(nil, booking_params.merge(cabin: @cabin)).create
        if result.success?
          render json: BookingSerializer.new(result.booking, include: ['cabin', 'user']), status: :created
        else
          render json: { errors: result.errors.map { |e| { detail: e } } }, status: :unprocessable_entity
        end
      end

      def update
        return render json: { errors: [{ detail: 'Booking not found' }] }, status: :not_found unless @booking

        result = Bookings::ManageService.new(@booking, booking_params).update
        if result.success?
          render json: BookingSerializer.new(result.booking, include: ['cabin', 'user']), status: :ok
        else
          render json: { errors: result.errors.map { |e| { detail: e } } }, status: :unprocessable_entity
        end
      end

      def destroy
        return render json: { errors: [{ detail: 'Booking not found' }] }, status: :not_found unless @booking

        if @booking.destroy
          render json: { meta: { message: 'Booking deleted successfully' } }, status: :ok
        else
          render json: { errors: @booking.errors.full_messages.map { |e| { detail: e } } }, status: :unprocessable_entity
        end
      end

      def after
        return render json: { errors: [{ detail: 'Invalid date' }] }, status: :bad_request unless valid_date?(params[:date])

        bookings = Booking.where('created_at >= ? AND created_at <= ?', Date.parse(params[:date]), Date.today.end_of_day)
          .select(:id, :created_at, :total_price, :extras_price)
        render json: {
          data: bookings.map do |b|
            {
              id: b.id,
              type: 'booking',
              attributes: {
                created_at: b.created_at,
                total_price: b.total_price,
                extras_price: b.extras_price
              }
            }
          end
        }, status: :ok
      end

      def stays_after
        return render json: { errors: [{ detail: 'Invalid date' }] }, status: :bad_request unless valid_date?(params[:date])

        stays = Booking.where('start_date >= ? AND start_date <= ?', Date.parse(params[:date]), Date.today)
          .includes(:user)
        render json: BookingSerializer.new(stays, include: ['user']), status: :ok
      end

      def today
        today = Date.today
        stays = Booking.where(
          '(status = ? AND start_date = ?) OR (status = ? AND end_date = ?)',
          'unconfirmed', today, 'checked-in', today
        ).includes(:user).order(:created_at)
        render json: BookingSerializer.new(stays, include: ['user']), status: :ok
      end

      private

      def set_cabin
        @cabin = Cabin.find_by(id: params[:cabin_id]) if params[:cabin_id]
      end

      def set_booking
        @booking = Booking.find_by(id: params[:id])
      end

      def booking_params
        params.require(:booking).permit(
          :start_date, :end_date, :user_id, :status, :total_price,
          :num_nights, :num_guests, :extras_price
        )
      end

      def valid_date?(date_str)
        Date.parse(date_str)
        true
      rescue ArgumentError
        false
      end
    end
  end
end