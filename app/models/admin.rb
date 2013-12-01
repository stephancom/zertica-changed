class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders
  has_many :active_chats, dependent: :destroy
  has_many :bids
  has_one :storefront

	def chat_channel
		"/admin_chat/#{id}"
	end

  def chat_partners
    (orders.map(&:user) + bids.map(&:user)).uniq
  end
end
