class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  before_action :authenticate_request
  before_action :check_meets

  private

  def authenticate_request
      # if request.headers["Authorization"].present?
      #   header = request.headers["Authorization"].split(" ").last
      #   begin
      #     decoded = JsonWebTokenService.decode(header)
      #     @current_user = User.where(id: decoded[:user_id])
      @current_user = User.where(id: "1c017f17-7b39-4c54-929b-de8f68e6eb55")
      #   rescue JWT::DecodeError
      #     render json: { error: I18n.t("error.sessions.invalid_token") }, status: 401
      #   end
      # else
      #   render json: { error: I18n.t("error.sessions.missing_header") }, status: 400
      # end
  end

  def current_user
    @current_user
  end

  # Check if all the meeting been in the past are finished
  def check_meets
    MeetsService.date_check()
  end
end
