class SessionsController < ApplicationController
    skip_before_action :authenticate_request, only: [ :oauth2_callback ]

    def oauth2_callback
        response = GoogleAuthService.get_access_token(params[:code])
        user_info = GoogleAuthService.get_user_info(response["access_token"])
        user = User.google_auth(user_info)

        if user.save
            token = JsonWebTokenService.encode(user_id: user.id)
            render json: { token: token }, status: 200
        else
            render json: { error: "Error creating user" }, status: 500
        end
    end

    def authorization_needed
        render json: { message: "You are authorized #{@current_user}" }, status: 200
    end
end
