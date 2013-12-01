class ActiveChat < ActiveRecord::Base
	belongs_to :user
	belongs_to :admin

	validates :user_id, uniqueness: {scope: :admin_id}, presence: true
	validates :admin_id, uniqueness: {scope: :user_id}, presence: true

	default_scope {includes(:user, :admin)}

	delegate :name, to: :user, prefix: true
	delegate :name, to: :admin, prefix: true

	def name
		"#{user_name} & #{admin_name}" rescue '--'
	end

	def message_channel
		@message_channel ||= "/chats/#{id}"
	end

	def messages
		@messages ||= Message.where(user: user, admin: admin)
	end
end
