Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  root 'static_pages#top'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  post 'posts_analysis', to: 'posts#analysis'
  # get 'posts_confirm', to: 'posts#confirm'
  get 'posts/confirm'
  # turboで投稿詳細画面を表示するためにdetailアクションを追加して、ルーティングも追加
  # get '/posts/detail/:id', to: 'posts#detail' 
  resources :users, only: %i[new create]

  resources :posts do
    resources :comments, only: %i[create update], shallow: true
    post 'analysis', on: :collection
  end

  resources :comments do
    collection do
      get :effectives
    end
  end
  resources :effectives, only: %i[create destroy]
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]
end
