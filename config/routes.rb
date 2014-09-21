Rails.application.routes.draw do
  scope :hooks do
    post '/jenkins', to: 'jenkins_hooks#create', as: :jenkins_hook
    get  '/jenkins', to: 'jenkins_hooks#index'

    post '/bitbucket', to: 'bitbucket_hooks#create', as: :bitbucket_hook
    get  '/bitbucket', to: 'bitbucket_hooks#index'
  end

  scope :bitbucket do
    scope :refresh do
      post '/:id', to: 'bitbucket_hooks#refresh', as: :bitbucket_refresh
      get  '/:id', to: 'bitbucket_hooks#refresh_button'

      post '/', to: 'bitbucket_hooks#refresh_all', as: :bitbucket_refresh_all
    end

    scope :automerge do
      post '/:id', to: 'bitbucket_hooks#automerge', as: :bitbucket_automerge
      get  '/:id', to: 'bitbucket_hooks#automerge_button'
    end
  end

  resources :message_examples, only: :index
  resources :pull_requests,    only: :index
  resources :jenkins_jobs,     only: :index

  root to: 'home#index'
end
