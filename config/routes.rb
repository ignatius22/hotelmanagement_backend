Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users,
        path: '',
        path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' },
        controllers: { sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations' },
        skip: [:passwords, :confirmations, :unlocks]

      post 'refresh', to: 'api/v1/users/sessions#refresh'

      # Global bookings endpoints
      resources :bookings, only: [:index, :show, :update, :destroy] do
        collection do
          get 'after/:date', to: 'bookings#after' # GET /api/v1/bookings/after/:date
          get 'stays/after/:date', to: 'bookings#stays_after' # GET /api/v1/bookings/stays/after/:date
          get 'today', to: 'bookings#today' # GET /api/v1/bookings/today
        end
      end

      resources :cabins, only: [:index, :show, :create, :update, :destroy] do
        resources :bookings, only: [:create] # POST /api/v1/cabins/:cabin_id/bookings
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