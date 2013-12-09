class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  load_and_authorize_resource :order

  #before_filter :load_project, except: :confirm_payment
  #load_and_authorize_resource :order, through: :project, shallow: true, except: :confirm_payment
  #before_filter :load_project_from_order, except: :confirm_payment

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
      respond_with @order_pool
    end
  end

  def new
    @order = Order.new(order_params)
  end

  def create
    @order = Order.new(order_params)
    if current_user
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

  # def pay
  #   unless @order.update(params[:order]) and @order.pay!
  #     flash[:error] = 'Payment failed'
  #   end
  #   respond_with @order
  # end

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

  # def confirm_payment
  #   @result = Braintree::TransparentRedirect.confirm(request.query_string)
  #   @order = Order.find(@result.transaction.custom_fields[:order_id]) if @result 
  #   if @result && @result.success?
  #     @order.update(confirmation: @result.transaction.id) and @order.pay!
  #   else
  #     flash[:error] = 'Payment failed'
  #   end
  #   redirect_to [@order]
  # end


#   def ship
#     @order.shippable_files.build(project: @project)
#     unless @order.update(params[:order]) and @order.ship!
#       flash[:error] = 'Shipment failed'
#     end
#     respond_with @project, @order
#   end

#   def archive
#     @order.archive!
#     respond_with @project    
#   end

# private
#   # this one gets done first, for when you've got a nested path
#   def load_project
#     @project ||= Project.find(params[:project_id]) if params.has_key? :project_id
#   end
#   # and this one gets done after, in case you're in a shallow path.
#   # there's probably a better, less redundant way to do this
#   def load_project_from_order
#     @project ||= @order.project if @order
#   end

  def order_params
    case action_name
    when 'new'  
      if current_admin
        params[:order].permit(:order_type, :subtotal, :title, :description, :price,
         :file_objects ,file_object_ids: [], file_objects_attributes: [:order_id,
          :url, :filename, :size, :mimetype])
      else
        params[:order].permit(:order_type, :subtotal, :admin_id,  :title, :deadline, :color, :material,
         :budget, :description, :file_objects, :quantity, :software_program, :file_format,
         file_object_ids: [], file_objects_attributes: [:order_id, :url, :filename,
          :size, :mimetype])
      end
    when 'create'
      if current_admin
        params[:order].permit(:order_type, :subtotal, :title, :description, :price,
         :file_objects ,file_object_ids: [], file_objects_attributes: [:order_id,
          :url, :filename, :size, :mimetype])
      else
        params[:order].permit(:order_type, :subtotal, :admin_id,  :title, :deadline, :color, :material,
         :budget, :description, :file_objects, :quantity, :software_program, :file_format,
         file_object_ids: [], file_objects_attributes: [:order_id, :url, :filename,
          :size, :mimetype])
      end
    when 'estimate'
      params[:order].permit(:price)
    when 'pay'
      params[:order].permit(:confirmation)
    when 'confirm_payment'
      params.require(:bt_message) # special case - braintree response
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
