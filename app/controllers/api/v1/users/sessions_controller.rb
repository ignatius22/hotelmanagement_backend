module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        include AuthorizationHelper
        respond_to :json
        rescue_from StandardError, with: :handle_server_error

        def create
          params[:user] ||= params.dig(:session, :user) || {}
          self.resource = warden.authenticate!(scope: :user, recall: "#{controller_path}#handle_authentication_failure")
          return handle_authentication_failure unless resource

          # Set is_authenticated to true
          resource.update!(is_authenticated: true)

          sign_in(:user, resource, store: false)
          # Generate JWT token
          token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
          request.env['warden-jwt_auth.token'] = token # Override default token
          respond_with_success(resource, token)
        end

        def destroy
          sign_out(resource_name)
          render json: { code: 200, message: 'Logged out successfully' }, status: :ok
        end

        private

        def respond_with_success(resource, token)
          payload = decode_jwt_payload(token)
          Rails.logger.info "Issued token payload: #{payload.inspect}"
          render json: {
            code: 200,
            message: 'Logged in successfully',
            data: {
              user: serialized_user(resource),
              token: token
            },
            meta: {
              issued_at: Time.at(payload['iat']).iso8601,
              expires_at: Time.at(payload['exp']).iso8601
            }
          }, status: :ok
        end

        def handle_authentication_failure
          Rails.logger.info "Authentication failed with params: #{params[:user].inspect}"
          render json: { code: 401, message: 'Invalid email or password' }, status: :unauthorized
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

        def handle_server_error(exception)
          Rails.logger.error("#{exception.class}: #{exception.message}\n#{exception.backtrace.join("\n")}")
          render json: { code: 500, message: 'Internal server error', errors: ['Something went wrong'] }, status: :internal_server_error
        end

        def decode_jwt_payload(token)
          Warden::JWTAuth::TokenDecoder.new.call(token)
        end
      end
    end
  end
end