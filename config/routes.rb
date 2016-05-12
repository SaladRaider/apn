Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :videos, :users, :assigned_jobs
  get '/join' => 'high_voltage/pages#show', id: 'join'
  get '/about' => 'high_voltage/pages#show', id: 'about'
  get '/contact' => 'high_voltage/pages#show', id: 'contact'
  get '/suggest' => 'high_voltage/pages#show', id: 'suggest'
end
