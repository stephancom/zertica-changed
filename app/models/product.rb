class Product < ActiveRecord::Base
	validates :title, presence: true
	validates :description, presence: true
	validates :price, presence: true
	validates :admin_id, presence: true
	belongs_to :admin, dependent: :destroy
	has_many :file_objects, dependent: :destroy
	accepts_nested_attributes_for :file_objects, reject_if: proc { |attributes| attributes[:url].blank? }


end
