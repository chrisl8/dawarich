# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'
  get 'settings/theme', to: 'settings#theme'
  get 'export', to: 'export#index'
  get 'export/download', to: 'export#download'

  resources :imports
  resources :points, only: %i[index] do
    collection do
      delete :bulk_destroy
    end
  end
  resources :stats, only: :index do
    collection do
      post :update
    end
  end
  get 'stats/:year', to: 'stats#show', constraints: { year: /\d{4}/ }

  root to: 'home#index'
  devise_for :users

  post 'settings/generate_api_key', to: 'devise/api_keys#create', as: :generate_api_key

  get 'map', to: 'map#index'

  namespace :api do
    namespace :v1 do
      resources :points

      namespace :overland do
        resources :batches, only: :create
      end
    end
  end
end
