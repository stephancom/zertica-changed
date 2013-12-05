class Storefront < ActiveRecord::Base
	validates :vendor_name, presence: true
	
	belongs_to :admin
end
