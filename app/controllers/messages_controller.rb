class MessagesController < ApplicationController
  load_and_authorize_resource

  before_filter :get_user
  before_filter :new_message, only: :index
  before_filter :update_last_saw_messages_at, only: [:index, :create], if: :current_user

  def index
    respond_with(@messages)
  end

  def create
    @message.user = @user || current_user
    @message.admin = current_admin
    @message.save
  end

  def bookmark
    @message.toggle!(:bookmark)
  end

  private

  def update_last_saw_messages_at
    current_user.update(last_saw_messages_at: Time.now)
  end

  def get_user
    @user = User.find(params[:user_id]) if params.has_key? :user_id
  end

  def new_message
    @message ||= @user.messages.new if @user
    @message ||= current_user.messages.new if current_user
  end

  def message_params
    params[:message].permit(:body, :bookmark)
  end
end
