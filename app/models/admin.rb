class Admin < ActiveRecord::Base
  include BalancedCustomer

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :sent_messages, as: :speaker
  has_many :active_chats, dependent: :destroy
  has_many :bids
  has_one :storefront
  has_many :products
	def chat_channel
		"/admin_chat/#{id}"
	end

  def chat_partners
    (orders.map(&:user) + bids.map(&:user)).uniq
  end

  def payable?
    not bank_account_uri.blank?
  end

  def add_bank_account!(uri)
    self.bank_account_uri = uri
    balanced_customer.add_bank_account(uri)
    save!
  end
end
