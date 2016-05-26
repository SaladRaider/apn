Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :videos, :users, :assigned_jobs, :contents, :contacts, :suggestions
  get '/join' => 'high_voltage/pages#show', id: 'join'
  get '/about' => 'users#index', id: 'about'
  get '/contact' => 'contacts#new', id: 'contact'
  get '/suggest' => 'suggestions#new', id: 'suggest'
  get '/thanks' => 'high_voltage/pages#show', id: 'thanks'
end
