Boarrd::Application.routes.draw do
  devise_for :users
  root :to => "welcome#index"
  resources :dashboards, :except => [:edit, :update] do
    collection do
      match "inputs_for/:widget_type" => "dashboards#inputs_for", :as => :inputs_for
    end
    member do
      get :reorder_widgets
    end
    resources :widgets, :only => [:create, :update, :destroy] do
      member do
        get :settings
      end
    end
  end
end
