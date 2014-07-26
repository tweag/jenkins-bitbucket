Rails.application.routes.draw do
  post '/hooks/jenkins', to: 'home#jenkins'
  root to: 'home#index'
end
