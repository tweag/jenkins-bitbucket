Rails.application.routes.draw do
  scope :hooks do
    post '/jenkins', to: 'jenkins_hooks#create', as: :jenkins_hook
    get  '/jenkins', to: 'jenkins_hooks#index'

    post '/bitbucket', to: 'bitbucket_hooks#create', as: :bitbucket_hook
    get  '/bitbucket', to: 'bitbucket_hooks#index'
  end

  scope :bitbucket do
    post '/refresh/:id', to: 'bitbucket_hooks#refresh', as: :bitbucket_refresh
    get  '/refresh/:id', to: 'bitbucket_hooks#refresh_button'
  end

  resources :message_examples, only: :index
  resources :pull_requests,    only: :index

  root to: 'home#index'
end
