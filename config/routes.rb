Rails.application.routes.draw do
  get 'news/index'

  root 'landing#index'

  namespace :api do
    resources :widget_payments, only: :new
    resources :payments,        only: :new
  end

  resources :news, only: :index
end
