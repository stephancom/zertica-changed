class ProductsController < ApplicationController
  before_filter :load_admin, :only => [:new, :create]
  load_and_authorize_resource :product

  def load_admin
    @admin = Admin.find(params[:admin_id])
  end

  def product_params
    params[:product].permit(:product_id, :admin_id, :title, 
      :description, :price, :file_objects ,file_object_ids: [], file_objects_attributes: [:product_id,
          :url, :filename, :size, :mimetype])
  end

  def new
    @product = @admin.products.new(params[:product])
  end

  def create
    @product = @admin.products.create(params[:product])
    if @product.save
      flash[:notice] = 'Your product has been added.'
      redirect_to root_path
    else
      redirect_to root_path, :alert => 'Unable to add product'
    end
  end

  def update
    @product = Product.find(params[:id])
    @product.update(params[:product])
    if @product.save
      redirect_to root_path
    end
  end
  def show
    @product = Product.find(params[:id])

  end

  def edit
    @product = Product.find(params[:id])
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to root_path, :notice => 'product deleted'
  end

end
