Rails.application.routes.draw do
  resources :inbounding_calls, only: [], defaults: {format: :xml} do
    collection do
      post 'forward'
      post 'hangup'
      post 'fallback'
      post 'voicemail'
    end
  end
end
