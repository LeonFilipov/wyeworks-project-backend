class SessionsController < ApplicationController
    skip_before_action :authenticate_request, only: [ :oauth2_callback ]

    def oauth2_callback
        response = GoogleAuthService.get_access_token(params[:code])
        user_info = GoogleAuthService.get_user_info(response["access_token"])
        firstTime = User.find_by(email: user_info["email"]).nil?
        user = User.google_auth(user_info)

        if user.save
            token = JsonWebTokenService.encode(user_id: user.id)
            if firstTime
                UserMailer.welcome_email_no_AR(user).deliver_now
            end
            render json: { token: token }, status: 200
        else
            render json: { error: I18n.t("error.users.not_created") }, status: 500
        end
    end
end
