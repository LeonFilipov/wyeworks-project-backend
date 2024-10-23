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
      rescue JWT::DecodeError
        render json: { error: "Invalid token" }, status: 401
      end
    else
      render json: { error: "Authorization header is missing" }, status: 400
    end
  end

  def current_user
    @current_user
  end
end
