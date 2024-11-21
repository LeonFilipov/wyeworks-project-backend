class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  before_action :authenticate_request
  before_action :check_meets

  private

  def authenticate_request
      if request.headers["Authorization"].present?
        header = request.headers["Authorization"].split(" ").last
        begin
          decoded = JsonWebTokenService.decode(header)
          @current_user = User.where(id: decoded[:user_id])
        # @current_user = User.where(id: "07aabec3-014e-4766-9d11-30b284f10cf8")
        rescue JWT::DecodeError
          render json: { error: I18n.t("error.sessions.invalid_token") }, status: 401
        end
      else
        render json: { error: I18n.t("error.sessions.missing_header") }, status: 400
      end
  end

  def current_user
    @current_user
  end

  # Check if all the meeting been in the past are finished
  def check_meets
    MeetsService.date_check()
  end
end
