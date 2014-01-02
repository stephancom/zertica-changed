class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  load_and_authorize_resource :order, except: :confirm_payment
  helper_method :sort_column, :sort_direction, :pool_sort_column

  def index
    if current_admin
      @orders = current_admin.orders.order(sort_column + ' ' + sort_direction)
    elsif current_user
      @orders = current_user.orders.order(sort_column + ' ' + sort_direction)     
    end
    respond_with @orders
  end

  def pool
    if current_admin
      @order_pool = Order.pool.order(pool_sort_column + ' ' + sort_direction)
      respond_with @order_pool
    end
  end

  def new
    @order = Order.new(params[:order])
  end

  def create
    @order = Order.create(params[:order])
    if current_user
      @order.user_id = current_user.id
    end
    @order.save
    respond_with @order
  end

  def update
    @order.update(params[:order])
    if @order.subtotal
      @order.subtotal = @order.subtotal.round
      @order.price = (@order.subtotal * 1.18).round
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
    @order.process_payment!(params[:card_uri])
    @order.pay!
    flash[:success] = "Thanks, you paid #{number_to_currency(@order.price)}"
    respond_with @order
  end

  def ship
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
    redirect_to root_path    
  end

private

  def sort_column
    params[:sort] || "title"
  end
  def pool_sort_column
    params[:sort] || "created_at"
  end
  def sort_direction
    params[:direction] || "asc"
  end
  def order_params
    case action_name
    when 'create'
      if current_admin
        params[:order].permit(:order_type, :budget, :city, :province, :subtotal, :title, :description, :price,
         :file_objects ,file_object_ids: [], file_objects_attributes: [:order_id,
          :url, :filename, :size, :mimetype])
      else
        params[:order].permit(:order_type, :budget, :subtotal, :city, :province, :admin_id, :title, :deadline, :color, :material,
         :budget, :description, :file_objects, :quantity, :software_program, :file_format,
         file_object_ids: [], file_objects_attributes: [:order_id, :url, :filename,
          :size, :mimetype])
      end
    when 'estimate'
      params[:order].permit(:price)
    when 'pay'
      params.require(:card_uri)
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
        params[:order].permit(:title, :city, :budget, :province, :subtotal, :description,:price, :file_objects,
         file_object_ids: [], file_objects_attributes: [:order_id, :url, :filename,
          :size, :mimetype], shippable_files_attributes: [:order_id, :url, :filename,
           :size, :mimetype])
      else
        params[:order].permit(:order_type, :budget, :subtotal, :city, :province, :admin_id, :title, :deadline, :color, :material,
         :budget, :description, :file_objects, :quantity, :software_program, :file_format,
         file_object_ids: [], file_objects_attributes: [:order_id, :url, :filename,
          :size, :mimetype])
      end
    end
    # TODO allow carrier/tracking number/shipping files if admin and state completed
  end
end
