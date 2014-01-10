class ActiveChatsController < ApplicationController
  #before_filter :authenticate_admin!

  load_and_authorize_resource through: :chatter

  before_filter :chat_partner, only: [:create, :destroy]

  def index
    @chat_partners = chatter.chat_partners
  end

  def create
    @active_chat = chatter.active_chats.create!(params[:active_chat])
    respond_with @active_chat
  end

  def destroy
    @active_chat.destroy
    respond_with @active_chat
  end

  private

  def chatter
    @chatter ||= current_user || current_admin
  end

  def chat_partner
    @chat_partner ||= @active_chat.user if current_admin
    @chat_partner ||= @active_chat.admin if current_user
    @chat_partner
  end

  def active_chat_params
    params[:active_chat].permit(:user_id, :admin_id)
  end
end
