Rails.application.routes.draw do
  root to: 'teachers#index'

  resources :teachers, only: [:index, :new, :create, :destroy]
  resources :requests do
    resources :courses, only: [:create]
  end
  resources :courses, only: [:destroy]
end
