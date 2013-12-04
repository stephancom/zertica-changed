class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  load_and_authorize_resource :order, except: :confirm_payment

  def index
    if current_admin
      @orders = current_admin.orders
    elsif current_user
      @orders = current_user.orders     
    end
    respond_with @orders
  end

  def pool
    if current_admin
      @order_pool = Order.pool
    end
    respond_with @order_pool
  end

  def create
    @order = Order.new(order_params)
    if current_admin 
      @order.admin_id = current_admin.id
    elsif current_user
      @order.user_id = current_user.id
    end
    @order.save
    respond_with @order
  end

  def update
    @order.update(order_params)
    if @order.subtotal
      @order.price = @order.subtotal * 1.15
    end
    if @order.save
      respond_with @order
    end
  end

  def destroy
    @order.destroy
    redirect_to root_path
  end

  def estimate
    unless @order.update(params[:order]) and @order.estimate!
      flash[:error] = 'Estimate failed'
    end
    respond_with @order
  end

  def pay
    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here https://manage.stripe.com/account
    Stripe.api_key = ENV['STRIPE_KEY'] || "wbkATEjTIb9vuZIEa9MHJWdZNVWGQB7U"

    # we build a hash for the parameters outside of the begin-rescue-end block
    # in case one of the other things going on here throws an error
    charge_details = {
      amount: (@order.price * 100).to_i,
      currency: :usd,
      card: params[:stripeToken],
      description: "Charge for Order: #{@order.title}. At an amount of #{number_to_currency @order.price}"
    }

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(charge_details)
      @order.confirmation = charge[:id]
      @order.pay!
      flash[:success] = "Thanks, you paid #{number_to_currency(charge[:amount]/100)}"
    rescue Stripe::CardError => e
      # The card has been declined
      flash[:error] = e.message
    end
    respond_with @order
  end

  def ship
    @order.shippable_files.build
    unless @order.update(params[:order]) and @order.ship!
      flash[:error] = 'Shipment failed'
    end
    respond_with @order
  end

  def complete
    @order.complete!
    respond_with @order
  end

  def archive
    @order.archive!
    respond_with @orders    
  end

private

  def order_params
    case action_name
    when 'create'
      if current_admin
        params[:order].permit(:order_type, :subtotal, :title, :description, :price,
         :file_objects ,file_object_ids: [], file_objects_attributes: [:order_id,
          :url, :filename, :size, :mimetype])
      else
        params[:order].permit(:order_type,:subtotal,  :title, :deadline, :color, :material,
         :budget, :description, :file_objects, :quantity, :software_program, :file_format,
         file_object_ids: [], file_objects_attributes: [:order_id, :url, :filename,
          :size, :mimetype])
      end
    when 'estimate'
      params[:order].permit(:price)
    when 'pay'
      params.require(:stripeToken)
    when 'complete'
      params[:order].permit()
    when 'ship'
      params[:order].permit(:carrier, :tracking_number, 
        shippable_file_ids: [], shippable_files_attributes: [:order_id, :url, 
          :filename, :size, :mimetype])
    when 'archive'
      params[:order].permit()
    else
      if current_admin
        params[:order].permit(:title, :subtotal, :description,:price, :file_objects,
         file_object_ids: [], file_objects_attributes: [:order_id, :url, :filename,
          :size, :mimetype], shippable_files_attributes: [:order_id, :url, :filename,
           :size, :mimetype])
      else
        params[:order].permit(:title, :admin_id, :price, :description, :file_objects, 
          file_object_ids: [], file_objects_attributes: [:order_id, :url, 
            :filename, :size, :mimetype])
      end
    end
    # TODO allow carrier/tracking number/shipping files if admin and state completed
  end
end
