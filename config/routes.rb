Rails.application.routes.draw do
  root to: 'anti_frauds#index'
  resources :transactions, only: [:index]
  resources :faqs, only: [:index]
  resources :anti_frauds, only:[:index, :create]
end
