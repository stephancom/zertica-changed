class UsersController < ApplicationController
  before_filter :authenticate_admin!
  load_and_authorize_resource
  before_filter :get_messages, only: :show
  before_filter :new_message, only: :show
  
  def update
    @user.update(params[:user])
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

  def notify
    @user.notify_on_next_message = true
    @user.save
  end

  private

  def user_params
    params[:user].permit(:name, :email, :password, :password_confirmation)
  end

  def get_messages
    @messages = @user.messages
  end

  def new_message
    @message = @user.messages.new
  end
end