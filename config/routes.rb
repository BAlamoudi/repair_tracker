Rails.application.routes.draw do
  # HTML pages
  get '/',          to: 'pages#login'
  get '/customer',  to: 'pages#customer'
  get '/workshop',  to: 'pages#workshop'
  get '/admin',     to: 'pages#admin'

  devise_for :users,
    path: 'auth',
    path_names: { sign_in: 'sign_in', sign_out: 'sign_out' },
    controllers: { sessions: 'auth/sessions' }

  namespace :api do
    resources :repair_requests, only: [:create, :index] do
      member do
        post :quote
        post :approve
        post :reject
      end
    end
  end
end