class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  before_action :authenticate_request

  private

  def authenticate_request
        # if request.headers["Authorization"].present?
        #   header = request.headers["Authorization"].split(" ").last
        #   begin
        #     decoded = JsonWebTokenService.decode(header)
        #     @current_user = User.where(id: decoded[:user_id])
        @current_user = User.find("ae706144-240f-4a9a-ad23-b431f3e0f35a")
     #     rescue JWT::DecodeError
     #       render json: { error: "Invalid token" }, status: 401
     #     end
     #   else
     #     render json: { error: "Authorization header is missing" }, status: 400
     #   end
   end
end
