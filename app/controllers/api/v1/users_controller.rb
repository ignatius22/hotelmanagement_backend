module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_with_jwt

      # GET /api/v1/users/current
      def current
        render json: {
          code: 200,
          message: 'Current user fetched successfully.',
          data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }, status: :ok
      end
    end
  end
end