module Authenticate 
  def authenticate_with_jwt
    token = request.headers['Authorization']&.split(' ')&.last
    if token.blank?
      render json: { code: 401, message: 'Authorization token is missing.' }, status: :unauthorized
      return
    end

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: 'HS256')
      user_id = decoded_token[0]['sub']
      @current_user = User.find_by(id: user_id)

      if @current_user.nil?
        render json: { code: 401, message: 'Invalid token or user not found.' }, status: :unauthorized
      end
    rescue JWT::ExpiredSignature
      render json: { code: 401, message: 'Token has expired.' }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { code: 401, message: 'Invalid token.' }, status: :unauthorized
    end
  end

  # Define a helper method to access the current user
  def current_user
    @current_user
  end
end