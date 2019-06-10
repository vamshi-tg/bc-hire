Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 
  root "static_pages#home"

  get '/candidate/application/new', to:"candidates#new_application_for_candidate", as: "new_candidate_application"
  post '/candidate/application', to: "candidates#create_application_for_candidate"

  get '/applications/:id/interview/new', to: "interviews#application_new_interview", as: "application_new_interview"
  post '/applications/:application_id/interviews', to: "interviews#create_interview_for_application", as: "application_interview_create"

  resources :candidates
  resources :applications, only: [:index, :show]

end
