class StorefrontsController < ApplicationController
	load_and_authorize_resource :storefront
	load_and_authorize_resource :admin

end
