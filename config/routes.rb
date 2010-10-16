Boarrd::Application.routes.draw do
  devise_for :users
  root :to => "welcome#index"
  resources :dashboards do
    collection do
      match "inputs_for/:widget_type" => "dashboards#inputs_for", :as => :inputs_for
    end
    resources :widgets do
      member do
        get :settings
      end
    end
  end
end
