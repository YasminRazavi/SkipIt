Skipit::Application.routes.draw do
  
  devise_for :users

  resources :pins


  resources :tracks


  resources :playlists do 
    member do
      get :tracks, to: "tracks#index"
    end
  end




devise_scope :user do
    # match 'profile' => 'users#profile', via: :get
    match 'users' => 'users#index', via: :get
    match 'users/:id' => 'users#show', via: :get


    root to: "devise/registrations#new"

  end

end
