class Product < ActiveRecord::Base
	validates :title, presence: true
	validates :description, presence: true
	validates :price, presence: true
	validates :admin_id, presence: true
	belongs_to :admin, dependent: :destroy
	has_many :file_objects
end
