class HomeController < ApplicationController
	def dashboard
		@clients = User.all
		@chats = current_admin.active_chats
		@projects = Project.all
	end
end
