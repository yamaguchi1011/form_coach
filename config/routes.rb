Rails.application.routes.draw do
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  post 'posts_analysis', to: 'posts#analysis'
  # get 'posts_confirm', to: 'posts#confirm'
  get 'posts/confirm'
  resources :users, only: %i[new create]
  
  resources :posts do
    resources :comments, only: %i[create], shallow: true
    # collection do
    #   get :effectives
    # end
  end

  resources :comments do
    collection do
      get :effectives
    end
  end
  resources :effectives, only: %i[create destroy]
  
end
