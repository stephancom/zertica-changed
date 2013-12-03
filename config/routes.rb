ZerticaConnect::Application.routes.draw do	


	devise_for :admins, :controllers => {:registrations => "admin_registrations"}
	devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
	
	resources :charges

	authenticated :admin do
		resources :admin, only: [:show] do 
			resources :storefronts
		end
		resources :active_chats, except: [:edit, :update, :new] do
			resources :messages, only: :create
		end
		match "/orders/pool" => "orders#pool", via: :get
		resources :users

		resources :orders do
			resources :file_objects
			resources :bids
			member do
				patch 'estimate'
				patch 'pay' 
				put 'complete'
				patch 'ship'
				patch 'archive'
			end
		end
		resources :file_objects

		root to: 'orders#index', as: :admin_root
	end

	authenticated :user do
		resources :storefronts, except: [:create, :edit, :update, :destroy, :new, :index]
		resources :active_chats, except: [:edit, :update, :new] do
			resources :messages, only: :create
		end
		resources :bids, except: [:create, :destroy] do 
			member do
				post 'select'	
			end
		end
		resources :orders do
			resources :file_objects, except: [:edit, :update]
			patch 'pay', on: :member # probably not needed, part of payment system
	
		end
		resources :file_objects

		root to: 'orders#index', as: :user_root
	end

	match 'order_confirm_payment' => 'orders#confirm_payment', :as => :order_confirm_payment, :via => :get

	root to: 'home#index', as: :root
end