Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html 
  root "static_pages#home"
  get 'static_pages/home'
  get 'login', to: "static_pages#login"

  resources :candidates
end
