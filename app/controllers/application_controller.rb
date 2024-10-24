class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  before_action :authenticate_request

  private

  def authenticate_request
    # if request.headers["Authorization"].present?
    #   header = request.headers["Authorization"].split(" ").last
    #   begin
    #     decoded = JsonWebTokenService.decode(header)
        @current_user = User.where(id: "1c017f17-7b39-4c54-929b-de8f68e6eb55")
    #   rescue JWT::DecodeError
    #     render json: { error: "Invalid token" }, status: 401
    #   end
    # else
    #   render json: { error: "Authorization header is missing" }, status: 400
    # end
  end
end
