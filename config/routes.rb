ZerticaConnect::Application.routes.draw do	

	devise_for :admins, :controllers => {:registrations => "admin_registrations"}
	devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }

	authenticated :admin do
		resources :active_chats, except: [:edit, :update, :new]
		match "/orders/pool" => "orders#pool", via: :get


		resources :messages, only: [] do
			patch 'bookmark', on: :member
		end
		resources :users do
			resources :messages, except: [:edit, :update, :destroy] do
				patch 'bookmark', on: :member
			end
			patch :notify, on: :member
		end
		

		resources :orders do
			resources :file_objects, except: [:edit, :update]
			resources :bids
			member do
				patch 'estimate'
				patch 'pay' 
				put 'complete'
				patch 'ship'
				patch 'archive'
			end
		end

		root to: 'orders#index', as: :admin_root
	end

	authenticated :user do
		put "bell/ring"

		resources :messages, except: [:edit, :update, :destroy] do
			patch 'bookmark', on: :member
		end

		resources :orders do
			resources :file_objects, except: [:edit, :update]
			patch 'pay', on: :member # probably not needed, part of payment system
		end

		root to: 'orders#index', as: :user_root
	end

	match 'order_confirm_payment' => 'orders#confirm_payment', :as => :order_confirm_payment, :via => :get

	root to: 'home#index', as: :root
end