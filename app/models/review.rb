class Review < ActiveRecord::Base
	belongs_to :storefront, dependent: :destroy
	belongs_to :user
	validates :title, presence: true
end
