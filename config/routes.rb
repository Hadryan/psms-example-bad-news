Rails.application.routes.draw do
  root 'landing#index'

  namespace :api do
    resources :widget_payments, only: :new
    resources :payments,        only: :new
  end

  resource :landing, only: :index
end
