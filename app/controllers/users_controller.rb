class UsersController < ApplicationController
    before_action :set_user, only: [ :teach, :learn ]

    # GET /profile/teach
    def profile_teach
      render json: teach_response(@current_user.first), status: :ok
    end

    # GET /users/:id/teach
    def teach
      user = User.where(id: params[:id])
      if user.present?
          render json: teach_response(@current_user.first), status: :ok
      else
          render json: { error: I18n.t("error.users.not_found") }, status: 404
      end
    end

    # GET /profile/learn
    def profile_learn
      render json: learn_response(@current_user.first), status: :ok
    end

    # GET /users/:id/learn
    def learn
      user = User.where(id: params[:id])
      if user.present?
          render json: learn_response(@current_user.first), status: :ok
      else
          render json: { error: I18n.t("error.users.not_found") }, status: 404
      end
    end

    # GET /profile
    def profile
      render json: [user_profile(@current_user.first)], status: 200
    end

    def show
      user = User.where(id: params[:id])
      if user.present?
          render json: user_profile(user), status: 200
      else
          render json: { error: I18n.t("error.users.not_found") }, status: 404
      end
    end

    def update
      begin
          @current_user.first.update(user_params)
          @current_user.first.save!
          render json: { message: I18n.t("success.users.updated") }, status: 200
        rescue ActionController::ParameterMissing => e
            render json: { error: I18n.t("error.users.parameter_missing", param: e.param) }, status: :unprocessable_entity
        rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ActiveRecord::RecordNotSaved => e
            render json: { error: e.message }, status: :unprocessable_entity
        rescue ActiveRecord::InvalidForeignKey => e
            render json: { error: I18n.t("error.careers.not_found") }, status: :not_found
        end
    end

    private

    def set_user
      @user = User.find_by(id: params[:id])
      render json: { error: I18n.t("error.users.not_found") }, status: :not_found unless @user
    end

    def user_params
      params.require(:user).permit(:name, :description, :career_id)
    end

    def teach_response(user)
      {
        meets_confirmed: meets_schema(MeetsService.tutor_meets_by_status(user, "confirmed")),
        meets_pending: meets_schema(MeetsService.tutor_meets_by_status(user, "pending")),
        meets_finished: meets_schema(MeetsService.tutor_meets_by_status(user, "finished")),
        topics: user.availability_tutors.map { |availability| { id: availability.topic.id, name: availability.topic.name } }
      }
    end

    def learn_response(user)
      {
        meets_confirmed: meets_schema(MeetsService.student_meets_by_status(user, "confirmed")),
        meets_pending: meets_schema(MeetsService.student_meets_by_status(user, "pending")),
        meets_finished: meets_schema(MeetsService.student_meets_by_status(user, "finished")),
        topics: user.interested_availability_tutors.map { |availability| { id: availability.topic.id, name: availability.topic.name } }
      }
    end

    def user_profile(user)
      career = user.career
      {
          id: user.id,
          name: user.name,
          email: user.email,
          description: user.description,
          image_url: user.image_url,
          career: career.nil? ? nil : {
              id: career.id,
              name: career.name
          }
      }
    end

    def meets_schema(meets)
      meets.map do |meet|
        {
          id: meet.id,
          status: meet.status,
          date: meet.date_time,
          topic: {
            id: meet.availability_tutor.topic.id,
            name: meet.availability_tutor.topic.name
          }
        }
      end
    end
end
