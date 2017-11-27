Rails.application.routes.draw do
  devise_for :authors, controllers: {
    sessions: 'authors/sessions'
  }
  root 'posts#index'
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
