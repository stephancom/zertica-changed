class Review < ActiveRecord::Base
	belongs_to :storefront
	belongs_to :user
	validates :title, presence: true
	validates :description, presence: true
	validates :rating, presence: true
end
