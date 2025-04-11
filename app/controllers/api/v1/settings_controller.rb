module Api
  module V1
    class SettingsController < ApplicationController
      before_action :set_setting, only: [:show, :update]

      # GET /api/v1/settings
      def index
        settings = Setting.all
        render json: SettingSerializer.new(settings).serializable_hash.to_json, status: :ok
      end

      # GET /api/v1/settings/:id
      def show
        render json: SettingSerializer.new(@setting).serializable_hash.to_json, status: :ok
      end

      # PUT /api/v1/settings/:id
      def update
        result = Settings::UpdateService.new(@setting, setting_params).call

        if result.success?
          render json: SettingSerializer.new(result.setting).serializable_hash.to_json, status: :ok
        else
          render json: {
            code: 422,
            message: 'Setting update failed.',
            errors: result.errors
          }, status: :unprocessable_entity
        end
      end

      private

      # Find setting by ID
      def set_setting
        @setting = Setting.find_by(id: params[:id])
        unless @setting
          render json: {
            code: 404,
            message: 'Setting not found.'
          }, status: :not_found
        end
      end

      # Permit setting parameters
      def setting_params
        params.require(:setting).permit(:min_booking_length, :max_booking_length, :max_guests_per_booking, :breakfast_price)
      end
    end
  end
end