class SessionsController < ApplicationController
    def oauth2_callback
        response = GoogleAuthService.get_access_token(params[:code])
        user_info = GoogleAuthService.get_user_info(response["access_token"])
        user = User.google_auth(user_info)

        if user.save
            render json: { user: user }, status: 200
        else
            render json: { error: "Error creating user" }, status: 500
        end
    end
end
