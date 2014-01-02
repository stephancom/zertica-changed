class Storefront < ActiveRecord::Base
	validates :vendor_name, presence: true
	has_many :reviews
	belongs_to :admin
	
end
