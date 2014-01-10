class ApplicationController < ActionController::Base
	force_ssl
	def current_ability
	  @current_ability ||= Ability.new(current_account)	
	end

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	respond_to :html, :js, :json

	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_path, :alert => exception.message
	end

	# https://github.com/ryanb/cancan/issues/835#issuecomment-18663815
	before_filter do
	  resource = controller_name.singularize.to_sym
	  method = "#{resource}_params"
	  params[resource] &&= send(method) if respond_to?(method, true)
	end

	before_filter :advise_admin

private
	# simple markup constant for the marketplace
	MARKUP = 0.18

	# notify admins to enter their banking info
	def advise_admin
		flash.now[:warning] = render_to_string(partial: 'bank_accounts/advise_flash') if current_admin and not current_admin.payable?
	end

	def current_account
		current_admin || current_user
	end
end
