# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'api/v1/games#result'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :games, only: :create do
        collection do
          get 'result'
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
