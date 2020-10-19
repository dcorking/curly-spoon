Rails.application.routes.draw do
  resources :posts do
    collection do
      get 'current'
      get 'expired'
    end
  end
end
