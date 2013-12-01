class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

	#has_many :projects, dependent: :destroy
	has_many :messages, dependent: :destroy
	has_many :active_chats, dependent: :destroy
	has_many :orders
	has_many :bids, through: :orders
	belongs_to :last_notified_message, class_name: 'Message'

	def chat_channel
		"/user_chat/#{id}"
	end

	def chat_partners
		(orders.map(&:admin) + bids.map(&:admin)).uniq
	end

	def received_messages
		messages.where('admin_id IS NOT NULL')
	end

	# should be called from a rake task via cron
	def notify_if_new_message
		unless received_messages.empty? # if there are any messages		
			last_message = received_messages.last

			# if you've never seen messages, or the last created one was later than the last time you've seen messages
			hasnt_seen_message = (last_saw_messages_at.nil? or (last_message.created_at > last_saw_messages_at))
			# if you've never been notified, or this message has a higher id than the last one you were notified of 
			hasnt_been_notified = (last_notified_message.nil? or (last_notified_message.id < last_message.id)) 
			if hasnt_seen_message and hasnt_been_notified 
				MessageNotifications.new_message(last_message).deliver
				update(last_notified_message: last_message)
				puts "Notifying #{self.name} of #{last_message.id}"
			end
		end
	end

	def first_name
		name.split(' ').first
	end

	def last_name
		name.split(' ').last
	end

	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
		user = User.where(provider: auth.provider, uid: auth.uid).first
		user ||= User.where(email: auth.info.email).first_or_create do |user|
			user.uid = auth.uid
			user.provider = auth.provider
			user.name ||= auth.extra.raw_info.name
			user.password ||= Devise.friendly_token[0,20]
		end
		user
	end
end