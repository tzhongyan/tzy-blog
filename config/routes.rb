Rails.application.routes.draw do
  devise_for :authors, controllers: {
    sessions: 'authors/sessions'
  }

  # Only authenticated authors can do the following
  authenticate :author do
    resources :posts, only: [:new, :create, :edit, :update, :destroy]
  end

  # Both authenticated and unauthenticated users can view index and individual page
  resources :posts, only: [:index, :show]

  root 'posts#index'
  
end
