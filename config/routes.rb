Rails.application.routes.draw do
  post '/hooks/jenkins', to: 'jenkins_hooks#create'
  root to: 'home#index'
end
