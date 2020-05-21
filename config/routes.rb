Rails.application.routes.draw do
  root to: 'teachers#index'

  resources :teachers, only: [:index, :new, :create, :destroy]
  resources :requests
end
