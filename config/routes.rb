Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  root 'sessions#new'
  get    'login'      => 'sessions#new'
  post   'login'      => 'sessions#create'
  delete 'logout'     => 'sessions#destroy'
  get 'signup' => 'users#new'
  resources :users
  resources :notes
end
