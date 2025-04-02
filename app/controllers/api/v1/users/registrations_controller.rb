module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_errors
        rescue_from StandardError, with: :handle_server_error

        # POST /api/v1/signup
        def create
          build_resource(sign_up_params)
          resource.save!
          yield resource if block_given?
          render_success_response(resource)
        rescue ActiveRecord::RecordInvalid => e
          handle_validation_errors(e)
        end

        private

        # Permit sign-up parameters
        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :avatar)
        end

        # Render success response
        def render_success_response(resource)
          render json: {
            code: 201,
            message: 'Signed up successfully.',
            data: serialized_user(resource)
          }, status: :created
        end

        # Render validation error response
        def handle_validation_errors(exception)
          render json: {
            code: 422,
            message: 'Validation failed.',
            errors: exception.record.errors.full_messages
          }, status: :unprocessable_entity
        end

        # Render server error response
        def handle_server_error(exception)
          Rails.logger.error("#{exception.class}: #{exception.message}")
          Rails.logger.error(exception.backtrace.join("\n"))
          render json: {
            code: 500,
            message: 'Internal server error.',
            errors: ['Something went wrong. Please try again later.']
          }, status: :internal_server_error
        end

        # Serialize user data
        def serialized_user(user)
          UserSerializer.new(user).serializable_hash[:data][:attributes]
        rescue NameError => e
          Rails.logger.error("Serializer not found: #{e.message}")
          {
            id: user.id,
            email: user.email,
            full_name: user.full_name,
            created_at: user.created_at,
            avatar: user.avatar.present? ? user.avatar.url : nil
          }
        end
      end
    end
  end
end