class FileObjectsController < ApplicationController
	load_and_authorize_resource :order
  load_and_authorize_resource :product
  load_and_authorize_resource :file_object

  def index
    respond_with(@file_objects)
  end

  def show
    respond_with(@file_object)
  end

  def new
    respond_with(@file_object)
  end

  def create
    @file_object.save
    respond_with(@file_object)
  end

  def update
    @file_object.update(params[:file_object])
    respond_with(@file_object)
  end

  def destroy
    @file_object.destroy
    respond_with(@file_objects)
  end

private

  def file_object_params
    params[:file_object].permit(:url, :filename, :size, :mimetype,
     :order_id, :product_id, :sendshapes_url)
  end


end
