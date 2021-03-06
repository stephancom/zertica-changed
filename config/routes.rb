ZerticaConnect::Application.routes.draw do	




	devise_for :admins, :controllers => {:registrations => "admin_registrations"}
	devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
	
	# resources :charges

	authenticated :admin do
		resources :products
		resource :bank_account, only: [:edit, :update]
		resources :admin, only: [:show] do 
			resources :storefronts do 
				resources :reviews, only: [:show]
			end
			resources :products do
			end
		end
		resources :active_chats, except: [:edit, :update, :new] do
			resources :messages, only: :create
		end
		match "/orders/pool" => "orders#pool", via: :get
		match "/orders/mybids" => "orders#mybids", via: :get
		resources :users

		resources :orders do
			resources :file_objects
			resources :bids
			member do
				patch 'estimate'
				put 'complete'
				patch 'ship'
				patch 'archive'
			end
		end
		resources :file_objects

		root to: 'orders#index', as: :admin_root
	end

	authenticated :user do
		resources :products
		resources :admin do 
			resources :storefronts do
				resources :reviews
				end
				resources :products do
				end
		end
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
			post 'pay', on: :member

		end
		resources :file_objects

		root to: 'orders#index', as: :user_root
	end

	root to: 'home#index', as: :root
end