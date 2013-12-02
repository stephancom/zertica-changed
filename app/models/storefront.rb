class Storefront < ActiveRecord::Base
	belongs_to :admin
	validates :admin_id, presence: true
	validates :vendor_name, presence: true
end
