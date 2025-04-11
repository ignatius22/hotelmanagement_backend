class ApplicationController < ActionController::API
  include Authenticate
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name avatar email password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name avatar])
  end
end