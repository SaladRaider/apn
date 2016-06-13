Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :videos, :assigned_jobs, :contents, :contacts, :suggestions, :users
  
  get "/join" => 'pages#show', format: false, id: 'join'
  get "/about" => 'users#index', format: false, id: 'about'
  get "/contact" => 'contacts#new', format: false, id: 'contact'
  get "/suggest" => 'pages#show', format: false, id: 'suggest'
  get "/thanks" => 'pages#show', format: false, id: 'thanks'
  get "/user_approval" => 'pages#show', format: false, id: 'user_approval'

  #get '/join' => 'high_voltage/pages#show', id: 'join'
  #get '/about' => 'users#index', id: 'about'
  #get '/contact' => 'contacts#new', id: 'contact'
  #get '/suggest' => 'suggestions#new', id: 'suggest'
  #get '/thanks' => 'high_voltage/pages#show', id: 'thanks'
  #get '/user_approval' => 'high_voltage/pages#show', id: 'user_approval'
end
