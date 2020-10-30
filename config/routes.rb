Foodlobby::Application.routes.draw do
  root :to => "households#index"

  devise_for :users
  
  # I can't delete:destroy to this path, I don't know why
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
  end

  resources :members

  match 'transactions(.:format)', :controller => :transactions, :action => :all_households, :as => :all_transactions, via: [:get, :post]

  match 'monthly_reports', :controller => :monthly_reports, :action => :index, :as => 'monthly_reports', via: [:get, :post]

  match 'test_exception', :controller => :test_exception, :action => :test_exception, via: [:get, :post]

  resources :households do
    resources :transactions
  end

end
