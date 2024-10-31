class MeetsController < ApplicationController
    before_action :set_meet, only: [ :update, :show ]

    def index
      meets = Meet.all
      if params[:topic_id].present?
        meets = meets.joins(availability_tutor: :topic)
                     .where(topics: { id: params[:topic_id] })
      end

      if params[:status].present?
        meets = meets.where(status: params[:status])
      end

      if params[:participant_id].present?
        meets = meets.joins(:participants).where(participants: { user_id: params[:participant_id] })
      end

      if params[:tutor_id].present?
        meets = meets.joins(availability_tutor: :user)
                     .where(users: { id: params[:tutor_id] })
      end
      render json: meets.select(:id, :date_time, :status, :description, :link, :count_interesteds), status: :ok
    end

    # GET /meets/:id
    def show
      render json: @meet.as_json(only: [ :id, :date_time, :status, :description, :link, :count_interesteds ]), status: :ok
    end

    # PATCH/PUT /meets/:id
    def update # confirm a meet
      @availability_tutor = AvailabilityTutor.find(@meet.availability_tutor_id)
      if @current_user.first.id != @availability_tutor.user_id
        render json: { error: I18n.t("error.users.not_allowed") }, status: :unauthorized
      elsif @meet.status != "pending"
        render json: { error: I18n.t("error.meets.already_status", status: "confirmed") }, status: :bad_request
      else
        @meet.status = "confirmed"
        @meet.date_time = params[:meet][:date]
        @meet.description = params[:meet][:description]
        @meet.save
        render json: { message: I18n.t("success.meets.confirmed") }, status: :ok
      end
    end

    private
      def set_meet
        @meet = Meet.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t("error.meets.not_found") }, status: :not_found
      end
end
