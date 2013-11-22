module MessagesHelper
	def sender_class(message)
		message.admin_id ? :staff : :myself
	end

	def message_attrs(message)
		{ id: dom_id(message), class: [dom_class(message), sender_class(message)] }
	end
end
