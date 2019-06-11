Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 
  root "static_pages#home"

  # For Authentication
  get 'login', to: redirect('/auth/google_oauth2'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  # For creating application for a candidate
  get '/candidate/application/new', to:"candidates#new_application_for_candidate", as: "new_candidate_application"
  post '/candidate/application', to: "candidates#create_application_for_candidate"

  # For creating interview for an application
  get '/applications/:id/interview/new', to: "interviews#application_new_interview", as: "application_new_interview"
  post '/applications/:application_id/interviews', to: "interviews#create_interview_for_application", as: "application_interview_create"

  get '/applications/:id/interview/:interview_id', to: "applications#show_application_interview", as: "application_interview"

  get '/applications/search', to: "applications#search"
  resources :candidates
  resources :applications, only: [:index, :show, :update]

end
