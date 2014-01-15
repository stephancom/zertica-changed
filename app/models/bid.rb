class Bid < ActiveRecord::Base
	belongs_to :admin
	belongs_to :order
	#validates :admin_id, presence: true
	validates :order_id, presence: true
	validates :price, numericality: {greater_than: 0}
	validates :subtotal, numericality: {greater_than: 0}
	validates :message, presence: true
	validates :pay_schedule, presence: true
	delegate :user, to: :order
	delegate :name, to: :admin, prefix: true
	delegate :storefront, to: :admin, allow_nil: true
end
