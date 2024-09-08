class SessionsController < ApplicationController
    def create
        user = User.google_auth(request.env['omniauth.auth']);
        if user.save
            session[:user_id] = user.id
            render json: { user: user}
        else
            render json: { status: 500, errors: user.errors.full_messages }
        end
    end
end
