Rails.application.routes.draw do
  post '/hooks/jenkins', to: 'jenkins_hooks#create', as: :jenkins_hook
  get  '/hooks/jenkins', to: 'jenkins_hooks#index'

  post '/hooks/bitbucket', to: 'bitbucket_hooks#create', as: :bitbucket_hook
  get  '/hooks/bitbucket', to: 'bitbucket_hooks#index'

  resource :test, only: :show
  root to: 'home#index'
end
