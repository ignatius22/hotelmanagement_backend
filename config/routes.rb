Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Scope for Devise routes
      devise_scope :user do
        devise_for :users,
          path: '',
          path_names: {
            sign_in: 'login',
            sign_out: 'logout',
            registration: 'signup'
          },
          controllers: {
            sessions: 'api/v1/users/sessions',
            registrations: 'api/v1/users/registrations'
          },
          skip: [:passwords, :confirmations, :unlocks]

        # Optional: Add custom routes if needed
        post 'refresh', to: 'api/v1/users/sessions#refresh'  # Token refresh
      end

      # API documentation endpoint (if using rswag or similar)
      get 'docs', to: 'api_docs#index'
    end
  end

  # Health check with more detail
  get '/api/v1/health', to: 'api/v1/health#check'
end