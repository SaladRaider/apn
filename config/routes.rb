Rails.application.routes.draw do
  resources :videos, :users
  root "videos#index"
end
