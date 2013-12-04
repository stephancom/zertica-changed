class ChargesController < ApplicationController
  	load_and_authorize_resource :order
	before_filter :load_order

	def load_order
	  @order = Order.find(params[:order_id])
	end
	
	def new
	end

	def create
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here https://manage.stripe.com/account
		Stripe.api_key = "wbkATEjTIb9vuZIEa9MHJWdZNVWGQB7U"

		# Get the credit card details submitted by the form
		token = params[:stripeToken]

		# Create the charge on Stripe's servers - this will charge the user's card
		begin
		amount = (@order.price * 100).to_i
		  charge = Stripe::Charge.create(
		    :amount => amount, # amount in cents, again
		    :currency => "usd",
		    :card => token,
            :description => "Charge for Order: #{@order.title}. At an amount of $#{@order.price}"
		  )
		rescue Stripe::CardError => e
		  # The card has been declined
		end
	end


end
