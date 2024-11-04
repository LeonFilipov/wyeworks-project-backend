class UsersController < ApplicationController
    before_action :set_user, only: [:teach, :learn]
  
    # GET /profile/teach
    def profile_teach
      render json: teach_response(current_user), status: :ok
    end
  
    # GET /users/:id/teach
    def teach
      render json: teach_response(@user), status: :ok
    end
  
    # GET /profile/learn
    def profile_learn
      render json: learn_response(current_user), status: :ok
    end
  
    # GET /users/:id/learn
    def learn
      render json: learn_response(@user), status: :ok
    end

    # GET /profile
    def profile
      render json: user_profile(@current_user.first), status: 200
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
  
    def user_params
      params.require(:user).permit(:name, :description, :career_id)
    end

    def teach_response(user)
      {
        meets_confirmed: meets_schema(MeetsService.user_confirmed_meets(user)),
        meets_pending: meets_schema(MeetsService.user_pending_meets(user)),
        meets_finished: meets_schema(MeetsService.user_finished_meets(user)),
        topics: user.topics.map { |topic| { id: topic.id, name: topic.name } }
      }
    end
  
    def learn_response(user)
      {
        meets_confirmed: meets_schema(MeetsService.user_confirmed_meets(user)),
        meets_pending: meets_schema(MeetsService.user_pending_meets(user)),
        meets_finished: meets_schema(MeetsService.user_finished_meets(user)),
        topics: user.interested_topics.map { |topic| { id: topic.id, name: topic.name } }
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
          date: meet.date,
          topic: {
            id: meet.topic.id,
            name: meet.topic.name
          }
        }
      end
    end
  end