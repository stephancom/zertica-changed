class Storefront < ActiveRecord::Base
	validates :vendor_name, presence: true
	has_many :reviews
	belongs_to :admin
	
	def rating
      @sum = 0
	  self.reviews.each do |review|
		@sum = @sum + review.rating 
	  end
	  @rating = (@sum / self.reviews.count.to_f)
	end





end
