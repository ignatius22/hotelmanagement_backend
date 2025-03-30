module JwtHandler
  extend ActiveSupport::Concern

  # Decode JWT and find the user
  def find_user_from_token
    token = extract_token_from_header
    jwt_payload = decode_jwt(token)
    User.find_by(id: jwt_payload['sub'], jti: jwt_payload['jti'])
  rescue JWT::DecodeError
    render_error(401, 'Invalid token.')
    nil
  rescue ActiveRecord::RecordNotFound
    render_error(404, 'User not found.')
    nil
  end

  private

  # Extract token from Authorization header
  def extract_token_from_header
    request.headers['Authorization']&.split(' ')&.last
  end

  # Decode JWT token
  def decode_jwt(token)
    JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
  end

  # Render error response
  def render_error(code, message)
    render json: { code: code, message: message }, status: code
  end
end