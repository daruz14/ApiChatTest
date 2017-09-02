class Api::ConversationsController < ApplicationController
  respond_to :json


  def index
    render json: Conversation.all, status: 200

  end

  def create
    #Arreglar los casos bordes y casos donde la conversacion ya esta creada!
    conversation = Conversation.create()
    userconversation = UserConversation.create(user_id: params[:firstu], conversation_id: conversation.id)
    userconversation2 = UserConversation.create(user_id: params[:secondu], conversation_id: conversation.id)
    if conversation
      render json: conversation, status:200
    else
      render json: {message: "no se puede crear la conversacion"}
    end

  end

  def show
    conversation = Conversation.find(params[:id])
    #messages = conversation.messages
    render json: {conversation: conversation}, status: 200
  end

  private
  def conversation_params
    params.require(:conversation).permit(:sender_id, :receiver_id)
  end
end
