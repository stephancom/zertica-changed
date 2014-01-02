class StorefrontsController < ApplicationController	
  before_filter :load_admin, except: :destroy
  load_and_authorize_resource :storefront
  load_and_authorize_resource :admin

  def load_admin
    @admin = Admin.find(params[:admin_id])
  end

  def storefront_params
    params[:storefront].permit(:admin_id, :ships, :cad, :print, :city, :state, :vendor_name, :description, :pickup)
  end

  def new
    @storefront = @admin.build_storefront(params[:storefront])
  end
  def update
    @storefront = Storefront.find(params[:id])
    @storefront.update(params[:storefront])
    if @storefront.save
      redirect_to admin_storefront_path
    end
  end
  def show
    @storefront = Storefront.find(params[:id])

  end

  def edit
    @storefront = Storefront.find(params[:id])
  end

  def create
    @storefront = @admin.create_storefront(params[:storefront])
    if @storefront.save
      flash[:notice] = 'Your storefront has been created.'
      redirect_to root_path
    else
      redirect_to root_path, :alert => 'Unable to create storefront'
    end
  end

  def destroy
    @storefront = @admin.storefront
    @storefront.destroy
    redirect_to root_path, :notice => 'storefront deleted'
  end

end
