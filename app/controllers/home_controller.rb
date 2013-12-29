class HomeController < ApplicationController
	layout 'home'
	def dashboard
		@clients = User.all
		@chats = current_admin.active_chats
		@projects = Project.all
	end
end
