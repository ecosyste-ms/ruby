require 'sidekiq/web'
require 'sidekiq-status/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
end if Rails.env.production?

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'
  
  mount Sidekiq::Web => "/sidekiq"
  mount PgHero::Engine, at: "pghero"

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :issues 
      resources :jobs
      resources :projects, constraints: { id: /.*/ }, only: [:index, :show] do
        collection do
          get :lookup
          get :packages
        end
        member do
          get :ping
        end
      end
    end
  end

  resources :projects, constraints: { id: /.*/ } do
    collection do
      post :lookup
      get :lookup
      get :dependencies
      get :packages
    end
    resources :releases, only: [:index, :show]
  end

  resources :releases, only: [:index]

  resources :issues, only: [:index]
  
  resources :contributors, only: [:index, :show] 

  resources :exports, only: [:index], path: 'open-data'

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unprocessable'
  get '/500', to: 'errors#internal'

  root "projects#index"
end
