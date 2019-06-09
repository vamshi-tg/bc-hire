Rails.application.routes.draw do
  get 'interviews/new'

  get 'interviews/create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 
  root "static_pages#home"

  post '/candidate/application', to: "candidates#create_application_for_candidate"
  get '/candidate/application/new', to:"candidates#new_application_for_candidate", as: "new_candidate_application"

  get '/applications/:id/interview/new', to: "interviews#application_new_interview", as: "application_new_interview"

  resources :candidates
  resources :applications, only: [:index, :show]
  resources :interviews, only: [:create]

end
