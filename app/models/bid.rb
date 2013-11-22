class Bid < ActiveRecord::Base
	belongs_to :admin
	belongs_to :order
	#validates :admin_id, presence: true
	validates :order_id, presence: true
	validates :price, presence: true
end
