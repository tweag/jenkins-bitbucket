Rails.application.routes.draw do
  post '/hooks/jenkins', to: 'jenkins_hooks#create', as: :jenkins_hook
  get  '/hooks/jenkins', to: 'jenkins_hooks#index'

  post '/hooks/bitbucket', to: 'bitbucket_hooks#create', as: :bitbucket_hook
  get  '/hooks/bitbucket', to: 'bitbucket_hooks#index'

  post '/bitbucket/refresh/:id', to: 'bitbucket_hooks#refresh'
  get  '/bitbucket/refresh/:id', to: 'bitbucket_hooks#refresh_button'

  resource :test, only: :show

  resources :pull_requests, only: :index

  get '/test/messages', to: 'tests#messages', as: 'test_messages'

  root to: 'home#index'
end
