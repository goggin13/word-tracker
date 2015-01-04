MyWords::Application.routes.draw do

  devise_for :users
  match '/heartbeat' => 'application#heartbeat', :via => :get

  get 'words/define' => 'words#define', as: :define
  resources :words, except: [:update, :edit] do
    resources :definitions, only: [:update, :create, :destroy, :edit]
  end

  root 'words#index'
end
