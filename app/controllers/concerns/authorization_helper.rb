module AuthorizationHelper
  extend ActiveSupport::Concern

  # Check if the Authorization header is present
  def valid_authorization_header?
    request.headers['Authorization'].present?
  end
end