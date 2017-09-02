Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :messages, format: :json, only: [:index, :show, :destroy, :create]
    put "/new_message" => 'messages#update'
    resources :users, format: :json, only: [:index, :show, :destroy]
    put "/new_user" => "users#update"
    resources :conversations, format: :json, only: [:index, :create]
  end
end
