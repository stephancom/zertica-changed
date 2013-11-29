class ActiveChatsController < ApplicationController
  #before_filter :authenticate_admin!
  load_and_authorize_resource 

  def index
    # I cleaned this up for you, eric.  This isn't how I would do it...
    # but this seemed like the most educational way to interpret how you were doing it.
    @chat_partners = current_admin.orders.map(&:user).uniq if current_admin
    @chat_partners = Admin.all if current_user
    @chat_partners ||= []
  end

  def create
    @active_chat = current_admin.active_chats.new(params[:active_chat])    
    @active_chat.save
  end

  def destroy
    @active_chat.destroy
    respond_with @active_chat
  end

  private

  def active_chat_params
    params[:active_chat].permit(:user_id)
  end
end
