Rails.application.routes.draw do

  mount Preroller::Engine => "/pre", :as => :preroller
  mount StreamAdmin::Engine => "/stream", :as => :stream

  match '/debug' => "home#debug", :as => :debug

  match 'login' => 'sessions#new', as: :login
  match 'logout' => 'sessions#destroy', as: :logout
  resources :sessions, only: [:create, :destroy]

  root :to => "home#index"
end
