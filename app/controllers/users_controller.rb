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
            render json: { error: I18n.t("error.users.not_found") }, status: 404
        end
    end

    def profile
        render json: user_profile(@current_user.first), status: 200
    end

    def update
        begin
            @current_user.first.update(user_params)
            @current_user.first.save!
            render json: { message: I18n.t("success.users.updated") }, status: 200
        rescue ActionController::ParameterMissing => e
            render json: { error: I18n.t("error.users.parameter_missing", param: e.param) }, status: :unprocessable_entity
        rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ActiveRecord::RecordNotSaved => e
            render json: { error: e.message }, status: :unprocessable_entity
        rescue ActiveRecord::InvalidForeignKey => e
            render json: { error: I18n.t("error.careers.not_found") }, status: :not_found
        end
    end

    def fake_user
        user = User.where(name: "Juan Pablo").last
        token = JsonWebTokenService.encode(user_id: user.id)
        render json: { user_token: token }, status: 200
    end

    private
        def user_params
            params.require(:user).permit(:name, :description, :career_id)
        end

        def user_profile(user)
            career = user.career
            {
                id: user.id,
                name: user.name,
                email: user.email,
                description: user.description,
                image_url: user.image_url,
                career: career.nil? ? nil : {
                    id: career.id,
                    name: career.name
                }
            }
        end
end
