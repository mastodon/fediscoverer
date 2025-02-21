Rails.application.routes.draw do
  mount FaspDataSharing::Engine, at: "/"
  mount FaspBase::Engine, at: "/"

  mount MissionControl::Jobs::Engine, at: "/jobs"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :fasp do
    namespace :account_search do
      namespace :v0 do
        resource :search, only: :show
      end
    end

    namespace :trends do
      namespace :v0 do
        resources :contents, only: :index, path: "content"
        resources :hashtags, only: :index
        resources :links, only: :index
      end
    end
  end

  resource :account_search, only: :show

  resources :content_trends, only: :index
  resources :hashtag_trends, only: :index
  resources :link_trends, only: :index

  root "fasp_base/homes#show"
end
