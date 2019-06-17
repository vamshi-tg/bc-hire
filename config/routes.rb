Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 
  root "static_pages#home"

  # For Authentication
  get 'login', to: 'sessions#new'
  get '/login/google', to: redirect('/auth/google_oauth2'), as: 'google_login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  # For creating application for a candidate
  get '/candidate/application/new', to:"candidates#new_application_for_candidate", as: "new_candidate_application"
  post '/candidate/application', to: "candidates#create_application_for_candidate"

  # For creating interview for an application
  get '/applications/:id/interview/new', to: "interviews#new", as: "application_new_interview"
  post '/applications/:application_id/interviews', to: "interviews#create", as: "application_interview_create"

  # For editing interview for an application
  get '/applications/:id/interview/:interview_id/edit', to: "interviews#edit", as: "application_edit_interview"
  patch '/applications/:id/interviews/:interview_id', to: "interviews#update", as: "application_interview_update"
  
  # Display interview for application
  get '/applications/:id/interview/:interview_id', to: "applications#show_application_interview", as: "application_interview"

  post '/interview/:id/comment', to: "feedbacks#create", as: "interview_comments"

  patch '/application/:id/status', to: "applications#update_status", as: "application_status"
  
  resources :candidates
  resources :applications, only: [:index, :show]

end
