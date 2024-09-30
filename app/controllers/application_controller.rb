class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  before_action :authenticate_request

  private
    def authenticate_request
      if request.headers["Authorization"].present?
        header = request.headers["Authorization"].split(" ").last
        begin
          decoded = JsonWebTokenService.decode(header)
          @current_user = User.where(id: decoded[:user_id])
      # @current_user = User.find("e4cf95f4-4f3e-4267-b3f1-78cc0e8a6fa4")
        rescue JWT::DecodeError
          render json: { error: "Invalid token" }, status: 401
        end
      else
        render json: { error: "Authorization header is missing" }, status: 400
      end
    end
end
