class Order < ActiveRecord::Base
	ORDER_TYPES = %w(CadOrder PrintOrder)
	belongs_to :user
	belongs_to :admin
    has_many :file_objects, dependent: :destroy
	has_many :bids, dependent: :destroy
	has_and_belongs_to_many :shippable_files, class_name: 'FileObject', join_table: 'orders_shippable_files'
	accepts_nested_attributes_for :file_objects, reject_if: proc { |attributes| attributes[:url].blank? }
	accepts_nested_attributes_for :shippable_files, reject_if: proc { |attributes| attributes[:url].blank? }

	delegate :name, to: :user, prefix: :true
	delegate :name, to: :admin, prefix: :true

	def cad_order?
		order_type == 'CadOrder'
	end
	def print_order?
		!cad_order?
	end
	def human_order_type
		cad_order? ? 'CAD' : 'Print'
	end
	def average
	    @subtotal = 0
		self.bids.each do |bid|
		  @subtotal = @subtotal + bid.price 
		end
		@average = @subtotal/self.bids.count unless self.bids.count == 0  
	end
	#belongs_to :project
	#has_and_belongs_to_many :projects
	#has_one :user, through: :project

	default_scope {where(['state <> ?', 'archived'])}
	scope :pool, -> { where(admin_id: nil) }
	# TODO
	

	validates :title, presence: true
	validates :description, presence: true
	validates :order_type, presence: true, inclusion: { in: ORDER_TYPES }
	#validates :project, presence: true
	validates :price, numericality: { greater_than: 0 }, allow_nil: true
	#validates :project_files, presence: true
	validates :user_id, presence: true

	# TODO
	# validate payment confirmation correct if paid by user?
	# validate tracking number correct format for carrier if print order?

	#delegate :title, to: :project, prefix: true

	include Stateflow

	#     _        _                       _    _          
	#  __| |_ __ _| |_ ___   _ __  __ _ __| |_ (_)_ _  ___ 
	# (_-<  _/ _` |  _/ -_) | '  \/ _` / _| ' \| | ' \/ -_)
	# /__/\__\__,_|\__\___| |_|_|_\__,_\__|_||_|_|_||_\___|

	# it's kind of non-standard to mix events and states when writing
	# a state machine, but I think it makes it more readable in this case.
	# STATES: submitted estimated production completed shipped archived
	stateflow do
		# per https://github.com/ryanza/stateflow/issues/44
		state_column :state # needs to be explicit because of STI

		initial :submitted

		# we start in submitted state
		state :submitted

		# making an estimate takes us to submitted state
		event :estimate do
			transitions to: :estimated, if: :has_price?
		end

		# send the estimate to the client on entry
		state :estimated do
			enter :notify_estimate
		end

		# if the client doesn't like the estimate, we go back to submitted
		event :modify do
			transitions from: :estimates, to: :submitted
		end

		# if the client has paid, go to production state
		event :pay do
			transitions from: :estimated, to: :production, if: :payment_processed?
		end

		# since the client has paid, tell everyone to start the job and send a thank you
		state :production do
			enter :notify_paid
		end

		# the job is done! 
		event :complete do
			transitions from: :production, to: :completed
		end

		# notify the client that the job is done on entry
		state :completed do
			enter :notify_complete
		end

		# if this a cad order, shippable? checks that there is a shipped file attached
		# if it is a print order, there must be a tracking number
		# implement correctly in the subclasses
		event :ship do
			transitions from: :completed, to: :shipped, if: :shippable?
		end

		state :shipped do
			enter :notify_shipped
		end

		event :archive do
			transitions from: :shipped, to: :archived
		end

		state :archived
	end

	# 	          _   _  __ _         _   _             
	#  _ _  ___| |_(_)/ _(_)__ __ _| |_(_)___ _ _  ___
	# | ' \/ _ \  _| |  _| / _/ _` |  _| / _ \ ' \(_-<
	# |_||_\___/\__|_|_| |_\__\__,_|\__|_\___/_||_/__/

	def notify_estimate
		unless self.user_id.nil?
			OrderNotifications.estimate(self).deliver if user.email_estimate
	    end
	end

	def notify_paid
		OrderNotifications.paid(self).deliver
		OrderNotifications.thank_you(self).deliver
	end

	def notify_complete
		unless self.user_id.nil?
		OrderNotifications.complete(self).deliver if user.email_complete
		end
	end

	def notify_shipped
		unless self.user_id.nil?
		OrderNotifications.shipped(self).deliver if user.email_shipped
		end
	end
                                                
	#     _        _                        _ _ _   _             
	#  __| |_ __ _| |_ ___   __ ___ _ _  __| (_) |_(_)___ _ _  ___
	# (_-<  _/ _` |  _/ -_) / _/ _ \ ' \/ _` | |  _| / _ \ ' \(_-<
	# /__/\__\__,_|\__\___| \__\___/_||_\__,_|_|\__|_\___/_||_/__/
                                                            
	def has_price?
		!price.nil?
	end

	def payment_processed?
		!confirmation.blank?
	end

	# if this is a cad order, make sure shippable files have been attached
	# for a print order, make sure the tracking number is not blank
	def shippable?
		if cad_order?
			shippable_files.any?
		else
			!tracking_number.blank?
		end
	end

	# source: http://gummydev.com/regex/
	CARRIER_REGEXPS = { 	fedex: /\b(1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\d\d\d ?\d\d\d\d ?\d\d\d)\b/i,
						usps: /\b(91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d|91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d)\b/i,
						ups: /\b(1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\d\d\d ?\d\d\d\d ?\d\d\d)\b/i,
						other: /.*/}
	CARRIERS = CARRIER_REGEXPS.keys					

	validates :carrier, inclusion: {in: CARRIERS }, allow_nil: true

	# this would be cute if scope worked, but it doesn't
	# CARRIER_REGEXS.each_paid do |carrier, regex|
	# 	validates :tracking_number, format: {with: regex}, {scope: (carrier == carrier.to_s)}
	# end

	def has_tracking_url?
		shipped? and print_order? and carrier != 'other'
	end

	# http://verysimple.com/2011/07/06/ups-tracking-url/
	def tracking_url
		case carrier
		when 'fedex'
			"http://www.fedex.com/Tracking?action=track&tracknumbers=#{tracking_number}"
		when 'ups'
			"http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=#{tracking_number}"
		when 'usps'
			"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=#{tracking_number}"
		else
			'#'
		end
	end
end
