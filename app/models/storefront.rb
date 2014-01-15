class Storefront < ActiveRecord::Base
	has_many :reviews, dependent: :destroy
	belongs_to :admin
	
	validates :vendor_name, presence: true
	validates :city, presence: true
	validates :state, presence: true
	validates :description, presence: true

	def rating
      @sum = 0
	  self.reviews.each do |review|
		@sum = @sum + review.rating 
	  end
	  @rating = (@sum / self.reviews.count.to_f).round(1) unless self.reviews.count == 0
	end

end
