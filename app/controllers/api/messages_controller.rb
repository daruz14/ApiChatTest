class Api::MessagesController < ApplicationController
  respond_to :json
   before_action :set_id, only: [:show, :update, :destroy]

  def index
    render json: Message.all, status: 200
  end

  def create
    if Conversation.find(params[:message][:conversation_id])
      message = Message.new(message_params)
      if message.save
          render json: { message: message }, status: 201
      else
          render json: { message: 'Falló creacion', message: message, params: message_params }, status: 500
      end
    else
      render json: {message: 'La conversación no existe'}
    end
  end

  def show
    if message = Message.where(id: @id).first
            render json: { message: message }, status: 200 if stale?(message)
        else
            render json: { message: 'Mensaje no existe' }, status: 404
        end
  end

  def update
    # First make sure all params are there if it's a PUT
        if request.put? && !Message.validate_params(message_params)
            return render json: { message: 'Faltan datos para el mensaje', params: message_params, expected_params: Message.required_params }, status: 400
        end
        if message = Message.where(id: @id).first
            # We have a product with this uuid
            if message.update(message_params)
                render json: { message: message }, status: 200
            else
                render json: { message: 'Falló actualización', params: message_params }, status: 500
            end
        else
            # Let's create a new message only if PUT
            unless request.put?
                return render json: { message: 'Mensaje no existe' }, status: 404
            end
            p "antes del new"
            message = Message.new(message_params)
            if message.save
                render json: { message: message }, status: 201
            else
                render json: { message: 'Falló creacion', message: message, params: message_params }, status: 500
            end
        end
  end

  def destroy
    if message = Message.where(id: @id).first
            message.destroy
            render json: { message: 'Mensaje eliminado' }, status: 200
        else
            render json: { message: 'Mensaje no existe' }, status: 404
        end
  end

  private

  def set_id
        if request.get? || request.head? || request.delete?
            @id = params[:id]
        else
            @id = params[:message][:id]
        end
    end

    def message_params
        params.require(:message).permit(:info, :conversation_id, :user_id)
    end

end
