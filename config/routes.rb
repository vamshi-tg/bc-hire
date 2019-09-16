Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 
  root 'sessions#home'

  # For Authentication
  get 'login', to: 'sessions#new'
  get '/login/google', to: redirect('/auth/google_oauth2'), as: 'google_login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  # For creating application for a candidate
  get '/candidate/application/new',
    to:"candidates#new_application_for_candidate",
    as: "new_candidate_application"
  post '/candidate/application',
    to: "candidates#create_application_for_candidate"

  # For editing application for a candidate
  get '/candidate/:candidate_id/application/:id/edit',
    to:"applications#edit",
    as: "edit_candidate_application"
  patch '/candidate/:candidate_id/application/:id',
    to: "applications#update",
    as: "candidate_application_update"

  # For creating interview for an application
  get '/applications/:id/interview/new',
    to: "interviews#new",
    as: "application_new_interview"
  post '/applications/:application_id/interviews',
    to: "interviews#create",
    as: "application_interview_create"

  # For editing interview for an application
  get '/applications/:id/interview/:interview_id/edit',
    to: "interviews#edit",
    as: "application_edit_interview"
  patch '/applications/:id/interviews/:interview_id',
    to: "interviews#update",
    as: "application_interview_update"
  
  post '/interview/:id/comment',
    to: "feedbacks#create",
    as: "interview_comments"

  patch '/application/:id/status',
    to: "applications#update_status",
    as: "application_status"
  
  resources :candidates
  resources :applications, only: [:index, :show]
  resources :interview do
    resources :topic_feedbacks, only: [] do
      collection do
        get 'bulk_edit', to: "topic_feedbacks#edit"
        put 'bulk_update', to: "topic_feedbacks#update"
        post 'bulk_create', to: "topic_feedbacks#create"
      end
    end
  end

  # Deprecated

  # Display interview for application
  # get '/applications/:id/interview/:interview_id', to: "applications#show_application_interview", as: "application_interview"


end
