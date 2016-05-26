Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :videos, :users, :assigned_jobs, :contents, :contacts
  get '/join' => 'high_voltage/pages#show', id: 'join'
  get '/about' => 'users#index', id: 'index'
  get '/contact' => 'contacts#new', id: 'new'
  get '/suggest' => 'high_voltage/pages#show', id: 'suggest'
end
