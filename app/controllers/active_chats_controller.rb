class ActiveChatsController < ApplicationController
  before_filter :authenticate_admin!
  load_and_authorize_resource

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
