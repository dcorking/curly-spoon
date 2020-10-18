Rails.application.routes.draw do
  resources :posts do
    get 'expired', on: :collection
  end
end
