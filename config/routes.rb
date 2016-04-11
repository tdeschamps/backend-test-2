Rails.application.routes.draw do
  root to: 'apps#index'
  resources :apps, only: :index do
    resources :calls, only: :index
  end

  resources :calls, only: :show
  resources :inbounding_calls, only: [], defaults: {format: :xml} do
    collection do
      post 'forward'
      post 'hangup'
      post 'fallback'
      post 'voicemail'
      post 'save_record'
    end
  end
end
