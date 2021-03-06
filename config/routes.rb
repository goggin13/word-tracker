MyWords::Application.routes.draw do

  resources :notes
  get '/quotes' => 'notes#quotes', as: :notes_quotes

  devise_for :users
  match '/heartbeat' => 'application#heartbeat', :via => :get

  get 'words/define' => 'words#define', as: :define

  get 'users/:id/words' => 'words#index', as: :user_words

  post 'texts' => 'texts#create'

  resources :words, except: [:update, :edit] do
    resources :definitions, only: [:update, :create, :destroy, :edit]
  end

  resources :emails, :only => [:new, :create]

  root 'words#index'
end
