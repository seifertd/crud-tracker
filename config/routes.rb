Crud::Application.routes.draw do
  resources :games

  get "home/index"
  resources :players
  root :to => 'home#index'
end
