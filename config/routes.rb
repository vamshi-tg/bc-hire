Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 
  root "static_pages#home"
  get 'static_pages/home'
  get 'login', to: "static_pages#login"

  post '/candidate/application', to: "candidates#create_application_for_candidate"
  get '/candidate/application/new', to:"candidates#new_application_for_candidate", as: "new_candidate_application"
  resources :candidates
  resources :applications, only: [:index]
end
