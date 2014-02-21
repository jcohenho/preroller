Rails.application.routes.draw do

  mount Preroller::Engine => "/pre", :as => :preroller

  match '/debug' => "home#debug", :as => :debug

  match 'login' => 'sessions#new', as: :login
  match 'logout' => 'sessions#destroy', as: :logout
  resources :sessions, only: [:create, :destroy]

  root :to => "home#index"
  match '/p/:key/:stream_key' => "public#preroll", :as => :preroll
end
