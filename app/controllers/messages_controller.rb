class MessagesController < ApplicationController
  load_and_authorize_resource :active_chat

  def create
    @message = @active_chat.messages.create(params[:message])
  end

  private

  def message_params
    params[:message].permit(:body, :bookmark)
  end
end
