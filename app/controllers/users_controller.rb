class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [ :fake_user ]

    def index
        users = User.all.select(:id, :name, :email, :description, :image_url)
        render json: users, status: 200
    end

    def show
        user = User.where(id: params[:id]).select(:id, :name, :email, :description, :image_url)
        if user.present?
            render json: user, status: 200
        else
            render json: { message: "User not found" }, status: 404
        end
    end

    def profile
        render json: @current_user.as_json(only: [ :id, :name, :email, :description, :image_url ]), status: 200
    end

    def update
        begin
            @current_user.update(user_params)
            render json: { message: "User updated" }, status: 200
        rescue ActionController::ParameterMissing => e
            render json: { error: e.message }, status: :unprocessable_entity
        end
    end

    def fake_user
        user = User.where(name: "John Doe").last
        token = JsonWebTokenService.encode(user_id: user.id)
        render json: { user_token: token }, status: 200
    end

    private
        def user_params
            params.require(:user).permit(:name, :description)
        end
end
