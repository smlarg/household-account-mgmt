Foodlobby::Application.routes.draw do
  root :to => "households#index"

  devise_for :users

  resources :members

  match 'transactions(.:format)', :controller => :transactions, :action => :all_households, :as => :all_transactions, via: [:get, :post]

  match 'monthly_reports', :controller => :monthly_reports, :action => :index, :as => 'monthly_reports', via: [:get, :post]

  match 'test_exception', :controller => :test_exception, :action => :test_exception, via: [:get, :post]

  resources :households do
    resources :transactions
  end

end
