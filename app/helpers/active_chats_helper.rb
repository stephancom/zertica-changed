module ActiveChatsHelper
	def chatters_class(chat)
		"chatters-#{dom_id(chat.user)}-#{dom_id(chat.admin)}"
	end
end
