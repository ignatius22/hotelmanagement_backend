Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users,
        path: '',
        path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' },
        controllers: { sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations' },
        skip: [:passwords, :confirmations, :unlocks]

      post 'refresh', to: 'api/v1/users/sessions#refresh'

      # Global bookings endpoint
      resources :bookings, only: [:index, :show] # GET /api/v1/bookings

      resources :cabins, only: [:index, :show, :create, :update, :destroy] do
        # Cabin-specific bookings
        resources :bookings, only: [:show, :create, :update, :destroy] do
          collection do
            get 'after/:date', to: 'bookings#after'
            get 'stays/after/:date', to: 'bookings#stays_after'
            get 'today', to: 'bookings#today'
          end
        end
      end

      resources :settings, only: [:index, :show, :update]
      get 'docs', to: 'api_docs#index'
      get 'health', to: 'api/v1/health#check'

      resources :users, only: [] do
        collection do
          get :current
        end
      end
    end
  end
end