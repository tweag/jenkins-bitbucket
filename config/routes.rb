Rails.application.routes.draw do
  post '/hooks/jenkins', to: 'jenkins_hooks#create', as: :jenkins_hook
  get  '/hooks/jenkins', to: 'jenkins_hooks#index'

  resource :test, only: :show
  root to: 'home#index'
end
