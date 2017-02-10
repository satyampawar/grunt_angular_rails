Rails.application.routes.draw do

	namespace :api, defaults: { format: 'json' } do
		resources :groups
		resources :bank_accounts do
			member do
			  post "debit"
			  get 'transaction_views'
			  post 'deposite'
			  post 'withdraw'
			end
		end
	end

  # scope '/api' do
  #   resources :groups, except: [:new, :edit]
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
