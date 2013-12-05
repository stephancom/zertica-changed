class ReviewsController < ApplicationController
  before_filter :load_storefront, except: :destroy
  load_and_authorize_resource :storefront
  load_and_authorize_resource :review

  def load_storefront
    @storefront = Storefront.find(params[:storefront_id])
  end

  def review_params
    params[:review].permit(:storefront_id, :user_id, :title, 
      :description, :rating)
  end

  def new
    @review = @storefront.reviews.new(params[:storefront])
  end

  def create
    @review = @storefront.reviews.create(params[:storefront])
    if @review.save
      flash[:notice] = 'Your review has been added.'
      redirect_to admin_storefront_path
    else
      redirect_to root_path, :alert => 'Unable to add review'
    end
  end

  def update
    @review = Review.find(params[:id])
    @review.update(params[:review])
    if @review.save
      redirect_to admin_storefront_path
    end
  end
  def show
    @review = Review.find(params[:id])

  end

  def edit
    @review = Review.find(params[:id])
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to root_path, :notice => 'storefront deleted'
  end

end
