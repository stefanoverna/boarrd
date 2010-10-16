Boarrd::Application.routes.draw do
  devise_for :users
  root :to => "welcome#index"
  resources :dashboards do
    resources :widgets
  end
end
