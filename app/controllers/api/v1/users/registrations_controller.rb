module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json
        
        rescue_from ActiveRecord::RecordInvalid, with: :render_validation_errors
        rescue_from StandardError, with: :render_server_error

        # Override create to handle custom parameter structure
        def create
          build_resource(sign_up_params)
          resource.save
          yield resource if block_given?
          respond_with(resource)
        end

        private

        # Handle both user[] and registration[user][] parameter structures
        def sign_up_params
          params[:user] ||= params.dig(:registration, :user) || {}
          params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :avatar)
        end

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render_success_response(resource)
          else
            render_error_response(resource)
          end
        end

        def render_success_response(resource)
          render json: {
            code: 201,
            message: 'Signed up successfully',
            data: serialized_user(resource)
          }, status: :created
        end

        def render_error_response(resource)
          render json: {
            code: 422,
            message: 'User creation failed',
            errors: resource.errors.details.transform_values(&:first)
          }, status: :unprocessable_entity
        end

        def render_validation_errors(exception)
          render json: {
            code: 422,
            message: 'Validation failed',
            errors: exception.record.errors.details.transform_values(&:first)
          }, status: :unprocessable_entity
        end

        def render_server_error(exception)
          Rails.logger.error(exception.message)
          render json: {
            code: 500,
            message: 'Internal server error',
            errors: ['Something went wrong']
          }, status: :internal_server_error
        end

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