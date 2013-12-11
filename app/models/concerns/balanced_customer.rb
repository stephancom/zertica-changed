#  _          _                     _ 
# | |__  __ _| |__ _ _ _  __ ___ __| |
# | '_ \/ _` | / _` | ' \/ _/ -_) _` |
# |_.__/\__,_|_\__,_|_||_\__\___\__,_|
#  __ _  _ __| |_ ___ _ __  ___ _ _ 
# / _| || (_-<  _/ _ \ '  \/ -_) '_|
# \__|\_,_/__/\__\___/_|_|_\___|_|  
#
# (c) 2013 stephan.com

module BalancedCustomer
	extend ActiveSupport::Concern

	included do
		before_destroy :remove_balanced_customer
	end

	def remove_balanced_customer
		balanced_customer.unstore
	end

	def balanced_customer
		return Balanced::Customer.find(self.customer_uri) if self.customer_uri

		begin
			customer = self.class.create_balanced_customer(
			:name   => self.name,
			:email  => self.email
			)
		rescue
			'There was error fetching the Balanced customer'
		end

		self.customer_uri = customer.uri
		self.save
		customer
	end

	module ClassMethods
		def create_balanced_customer(params = {})
			begin
				Balanced::Marketplace.mine.create_customer(
					:name   => params[:name],
					:email  => params[:email]
				)
			rescue
				'There was an error adding a customer'
			end
		end
	end

end