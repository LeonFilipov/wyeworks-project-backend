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
        #@current_user = User.find("9aa69202-f304-4571-8478-b039af3f9414")
        @current_user = User.find("9aa69202-f304-4571-8478-b039af3f9414")
        # "9aa69202-f304-4571-8478-b039af3f9414" 1 
        # "07aabec3-014e-4766-9d11-30b284f10cf8" 2
    #   rescue JWT::DecodeError
    #     render json: { error: "Invalid token" }, status: 401
    #   end
    # else
    #   render json: { error: "Authorization header is missing" }, status: 400
    # end
  end
end
