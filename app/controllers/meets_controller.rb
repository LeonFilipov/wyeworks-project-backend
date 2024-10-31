class MeetsController < ApplicationController
    before_action :set_meet, only: [ :update, :show, :add_interest, :remove_interest ]

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

    # POST /meets/:id/interesteds
    def add_interest
      if @meet.availability_tutor.user_id == @current_user.first.id
        render json: { error: I18n.t("error.meets.tutor_interested") }, status: :bad_request
        return
      end
      if @meet.status == "cancelled" || @meet.status == "completed"
        render json: { error: I18n.t("error.meets.already_status", status: @meet.status) }, status: :bad_request
      else
        if Participant.find_by(user_id: @current_user.first.id, meet_id: @meet.id)
          render json: { error: I18n.t("error.meets.already_interested") }, status: :bad_request
          return
        end
        participant = Participant.new(user_id: @current_user.first.id, meet_id: @meet.id)
        begin 
          if participant.save!
            @meet.count_interesteds += 1
            @meet.save!
            Interested.find_or_create_by!(user_id: @current_user.first.id, availability_tutor_id: @meet.availability_tutor_id)
            render json: { message: I18n.t("success.meets.interested") }, status: :ok
          end
        rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
          render json: { error: e.message }, status: :bad_request
        end
      end
    end

    # DELETE /meets/:id/interesteds
    def remove_interest
      if @meet.status == "cancelled" || @meet.status == "completed"
        render json: { error: I18n.t("error.meets.already_status", status: @meet.status) }, status: :bad_request
      else
        participant = Participant.find_by(user_id: @current_user.first.id, meet_id: @meet.id)
        if participant.nil?
          render json: { error: I18n.t("error.participants.not_found") }, status: :not_found
        else
          participant.destroy
          @meet.count_interesteds -= 1
          @meet.save!
          meets = Meet.where(availability_tutor_id: @meet.availability_tutor_id)
          if Participant.where(user_id: @current_user.first.id, meet_id: meets.pluck(:id)).empty?
            interested = Interested.find_by(user_id: @current_user.first.id, availability_tutor_id: @meet.availability_tutor_id)
            interested.destroy
          end
          render json: { message: I18n.t("success.meets.not_interested") }, status: :ok
        end
      end
    end

    private
      def set_meet
        @meet = Meet.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: I18n.t("error.meets.not_found") }, status: :not_found
      end
end
