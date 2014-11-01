Rails.application.routes.draw do
	namespace :api do
    resources :recipes
  end

  # Catch all 
  get "*path", to: "application#index"
  root 'application#index'
end
