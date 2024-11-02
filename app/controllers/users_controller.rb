class UsersController < ApplicationController
    before_action :set_user, only: [:show, :teach, :learn]
  
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
  
    private
  
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