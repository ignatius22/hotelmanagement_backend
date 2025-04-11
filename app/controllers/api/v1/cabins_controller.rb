module Api
  module V1
    class CabinsController < ApplicationController
      before_action :authenticate_with_jwt
      before_action :set_cabin, only: [:show, :update, :destroy]

      # GET /api/v1/cabins
      def index
        cabins = Cabin.all
        render json: CabinSerializer.new(cabins).serializable_hash.to_json, status: :ok
      end

      # GET /api/v1/cabins/:id
      def show
        render json: CabinSerializer.new(@cabin).serializable_hash.to_json, status: :ok
      end

      # POST /api/v1/cabins
      def create
        result = Cabins::ManageService.new(nil, cabin_params).create

        if result.success?
          render json: CabinSerializer.new(result.cabin).serializable_hash.to_json, status: :created
        else
          render_error(422, 'Cabin creation failed.', result.errors)
        end
      end

      # PUT /api/v1/cabins/:id
      def update
        result = Cabins::ManageService.new(@cabin, cabin_params).update

        if result.success?
          render json: CabinSerializer.new(result.cabin).serializable_hash.to_json, status: :ok
        else
          render_error(422, 'Cabin update failed.', result.errors)
        end
      end

      # DELETE /api/v1/cabins/:id
      def destroy
        @cabin.destroy
        render json: {
          code: 200,
          message: 'Cabin deleted successfully.'
        }, status: :ok
      end

      private

      # Find the cabin by ID
      def set_cabin
        @cabin = Cabin.find_by(id: params[:id])
        render_error(404, 'Cabin not found.') unless @cabin
      end

      # Strong parameters for cabin
      def cabin_params
        params.require(:cabin).permit(:max_capacity, :regular_price, :discount, :description, :image)
      end

      # Helper method to render error responses
      def render_error(status, message, errors = [])
        render json: {
          code: status,
          message: message,
          errors: errors
        }, status: status
      end
    end
  end
end