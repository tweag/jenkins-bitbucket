Rails.application.routes.draw do
  post '/hooks/jenkins', to: 'jenkins_hooks#create', as: :jenkins_hook
  root to: 'home#index'
end
