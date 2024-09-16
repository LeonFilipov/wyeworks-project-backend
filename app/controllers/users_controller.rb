class UsersController < ApplicationController

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

    def update
        begin
            @current_user.update(user_params)
            render json: { message: "User updated" }, status: 200
        rescue ActionController::ParameterMissing => e
            render json: { error: e.message}, status: :unprocessable_entity
        end
    end

    private
        def user_params
            params.require(:user).permit(:name, :description);
        end
end
