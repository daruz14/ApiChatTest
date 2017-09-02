class Api::UsersController < ApplicationController
  respond_to :json
  before_action :set_id, only: [:show, :update, :destroy]

  def index
    render json: User.all, status: 200
  end

  def show
    if user = User.where(id: @id).first
      conversations = []
      user.user_conversations.each do |p|
        conversations.push p.conversation
      end
      render json: { user: user, conversations: conversations }, status: 200 if stale?(user)
    else
      render json: { user: 'Mensaje no existe' }, status: 404
    end
  end

  def update
    # First make sure all params are there if it's a PUT
        if request.put? && !User.validate_params(user_params)
            return render json: { user: 'Faltan datos para el mensaje', params: user_params, expected_params: User.required_params }, status: 400
        end
        if user = User.where(id: @id).first
            # We have a product with this uuid
            if user.update(user_params)
                render json: { user: user }, status: 200
            else
                render json: { user: 'Falló actualización', params: user_params }, status: 500
            end
        else
            # Let's create a new user only if PUT
            unless request.put?
                return render json: { user: 'Mensaje no existe' }, status: 404
            end
            p "antes del new"
            user = User.new(name: params[:user][:name], password: params[:user][:password])
            if user.save
                render json: { user: user }, status: 201
            else
                render json: { user: 'Falló creacion', user: user, params: user_params }, status: 500
            end
        end
  end

  def destroy
    if user = User.where(id: @id).first
            user.destroy
            render json: { user: 'Mensaje eliminado' }, status: 200
        else
            render json: { user: 'Mensaje no existe' }, status: 404
        end
  end

  private

  def set_id
        if request.get? || request.head? || request.delete?
            @id = params[:id]
        else
            @id = params[:user][:id]
        end
    end

    def user_params
        params.require(:user).permit(:name, :password, :id)
    end

end
