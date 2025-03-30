module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        include JwtHandler
        include AuthorizationHelper

        respond_to :json
        rescue_from StandardError, with: :render_server_error

        def create
          params[:user] ||= params.dig(:session, :user) || {}
          self.resource = warden.authenticate!(scope: :user, recall: "#{controller_path}#respond_to_on_failure")
          return respond_to_on_failure unless resource

          sign_in(resource_name, resource, store: false)
          respond_with(resource)
        end

        private

        def respond_with(resource, _opts = {})
          token = request.env['warden-jwt_auth.token']
          payload = Warden::JWTAuth::TokenDecoder.new.call(token)

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

        def respond_to_on_failure
          Rails.logger.info "Authentication failed with params: #{params[:user].inspect}"
          render json: { code: 401, message: 'Invalid email or password' }, status: :unauthorized
        end

        def serialized_user(user)
          UserSerializer.new(user).serializable_hash[:data][:attributes]
        rescue NameError => e
          Rails.logger.error("Serializer not found: #{e.message}")
          { id: user.id, email: user.email, full_name: user.full_name, created_at: user.created_at, avatar: user.avatar.present? ? user.avatar.url : nil }
        end

        def render_server_error(exception)
          Rails.logger.error("#{exception.class}: #{exception.message}")
          Rails.logger.error(exception.backtrace.join("\n"))
          render json: { code: 500, message: 'Internal server error', errors: ['Something went wrong'] }, status: :internal_server_error
        end
      end
    end
  end
end