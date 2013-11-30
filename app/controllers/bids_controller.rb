class BidsController < ApplicationController
  before_filter :load_order, except: :destroy
  load_and_authorize_resource :bid
  load_and_authorize_resource :order

  def load_order
    @order = Order.find(params[:order_id])
  end

  def bid_params 
    params[:bid].permit(:admin_id, :pay_schedule, :message, :order_id, :price, :selected)
  end

  def index
    @bids = @order.bids
  end

  def select
    @bid = @order.bids.find(params[:id])
    @order.price = @bid.price
    @order.admin_id = @bid.admin_id
    @order.state = 'estimated'
    @bid.selected = true
    if @bid.save && @order.save
      redirect_to @order
    end
  end

  def new
    @bid = @order.bids.new(params[:bid])
  end

  def show
    @bid = Bid.find(params[:id])

  end

  def edit
    @bid = Bid.find(params[:id])
  end

  def create
    @bid = @order.bids.new(params[:bid])
    @bid.price = @bid.price * 1.15
    if current_admin
      @bid.admin_id = current_admin.id
    end
    if @bid.save
      flash[:notice] = 'Your bid was added.'
      redirect_to @order

    else
      redirect_to @order, :alert => 'Unable to add bid'
    end
  end

  # def bid_params
  #   params.require(:bid).permit!
  # end



  # def update
  #   @bid = Bid.find(params[:id])
  #   respond_to do |format|
  #     if @task.update_attributes(task_params)
  #       format.html { redirect_to @order, notice: 'Task was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @task.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    @bid = @order.bids.find(params[:bid_id])
    @bid.destroy
    redirect_to @order, :notice => 'Bid deleted'
  end



  # # GET /bids
  # # GET /bids.xml
  # def index
  #   @bids = Bid.all
  #   respond_with(@bids)
  # end

  # # GET /bids/1
  # # GET /bids/1.xml
  # def show
  #   @bid = Bid.find(params[:id])
  #   respond_with(@bid)
  # end

  # # GET /bids/new
  # # GET /bids/new.xml
  # def new
  #   @bid = Bid.new
  #   respond_with(@bid)
  # end

  # # GET /bids/1/edit
  # def edit
  #   @bid = Bid.find(params[:id])
  # end

  # # POST /bids
  # # POST /bids.xml
  # def create
  #   @bid = Bid.new(bid_params)
  #   flash[:notice] = 'Bid was successfully created.' if @bid.save
  #   respond_with(@bid)
  # end

  # # PUT /bids/1
  # # PUT /bids/1.xml
  # def update
  #   @bid = Bid.find(params[:id])
  #   flash[:notice] = 'Bid was successfully updated.' if @bid.update(params[:bid])
  #   respond_with(@bid)
  # end

  # # DELETE /bids/1
  # # DELETE /bids/1.xml
  # def destroy
  #   @bid = Bid.find(params[:id])
  #   @bid.destroy
  #   respond_with(@bid)
  # end
end
