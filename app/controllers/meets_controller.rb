class MeetsController < ApplicationController
    before_action :set_availability_tutor, only: [ :index ]
    before_action :set_meet, only: [ :confirm_pending_meet ]

    # GET /availability_tutors/:availability_tutor_id/meets
    def index
      # Return all meetings associated with a specific availability tutor
      meets = @availability_tutor.meets
      render json: meets, status: :ok
    end

    # POST /meets/:id
    def confirm_pending_meet
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
        render json: { message: I18n.t("success.meets.confirmed")}, status: :ok
      end
    end

    # GET /available_meets
    def available_meets
      # Return all available meetings

      meets = Meet.includes(:availability_tutor, :users)
                  .joins(:availability_tutor)

      if params[:id_availability_tutor].present?
        meets = meets.where(availability_tutor_id: params[:id_availability_tutor])
      end

      if params[:topic_id].present?
        meets = meets.joins(availability_tutor: :topic)
                     .where(availability_tutors: { topic_id: params[:topic_id] })
      end

      if params[:subject_id].present?
        meets = meets.joins(availability_tutor: { topic: :subject })
                     .where(topics: { subject_id: params[:subject_id] })
      end

      if params[:interested].present?
        interested = params[:interested].to_s.downcase == "true"
        if interested
          meets = meets.joins(:participants).where(participants: { user_id: @current_user.first.id })
        else
          meets = meets.where.not(id: meets.joins(:participants).where(participants: { user_id: @current_user.first.id }))
        end
      end

      if params[:meet_state].present?
        meets = meets.where(status: map_meeting_status(params[:meet_state]))
      end

      meets_data = meets.map do |meet|
        subject = meet.availability_tutor.topic.subject

        {
          id: meet.id,
          topic_name: meet.availability_tutor.topic.name,
          meeting_date: meet.date_time,
          meet_status: meet.status,
          tutor: {
            id: meet.availability_tutor.user.id,
            name: meet.availability_tutor.user.name
          },
          subject: {
            id: subject.id,
            name: subject.name
          },
          interested: meet.users.include?(@current_user.first),
          count_interesteds: meet.users.size
        }
      end

      render json: meets_data, status: :ok
    end

    # POST/DELETE /meets/:id/interest
    def interest
      meet = Meet.find(params[:id])
      availability_tutor = meet.availability_tutor
      debug_messages = []

      case request.method
      when "POST"
        existing_interest = Interested.find_by(user: @current_user.first, availability_tutor: availability_tutor)
        debug_messages << "User has existing interest in availability tutor: #{existing_interest.present?}"

        unless existing_interest
          Interested.create!(user: @current_user.first, availability_tutor: availability_tutor)
          debug_messages << "User's interest added to availability tutor."
        end

        if meet.users.include?(@current_user.first)
          render json: { error: I18n.t("error.meets.already_interested"), debug: debug_messages }, status: :bad_request
        else
          meet.users << @current_user.first
          meet.increment!(:count_interesteds)  # Incrementa el contador de interesados
          debug_messages << "User's interest added to meet."
          render json: { message: I18n.t("success.meets.interested"), debug: debug_messages }, status: :ok
        end

      when "DELETE"
        if meet.users.include?(@current_user.first)
          meet.users.delete(@current_user.first)
          meet.decrement!(:count_interesteds)  # Decrementa el contador de interesados
          render json: { message: I18n.t("success.meets.interest_removed")}, status: :ok
        else
          render json: { error: I18n.t("error.meets.not_interested") }, status: :bad_request
        end
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("error.meets.not_found") }, status: :not_found
    end

    # GET /profile/meets
    def my_meets
      meets = Meet.joins(:availability_tutor)
                  .where(availability_tutors: {
                    user_id: @current_user.first.id
                  })
      response = meets.map do |meet|
                  format_meet(meet)
                 end
      render json: response, status: :ok
    end
    # GET/PATCH /profile/meets/:id
    def my_meet
      meet = Meet.find_by(id: params[:id])

      if meet.nil? # Verifica si la reunión pertenece al usuario
        render json: { error: I18n.t("error.meets.not_found") }, status: :not_found # 404
        return
      elsif meet.availability_tutor.user_id != @current_user.first.id
        render json: { error: I18n.t("error.users.not_allowed") }, status: :unauthorized # 401
        return
      end

      case request.method
      when "GET"
        render json: format_meet(meet), status: :ok
      when "PATCH"
        if meet.status == "cancelled" || meet.status == "completed"
          render json: { error: I18n.t("error.meets.already_status", status: meet.status) }, status: :unprocessable_entity
        elsif meet.update(status: "cancelled")
          render json: { message: I18n.t("success.meets.cancelled") }, status: :ok
        else
          render json: { error: I18n.t("error.meets.failed", action: "cancel") }, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("error.meets.not_found") }, status: :not_found
    end


    private
      def format_meet(meet)
        availability = meet.availability_tutor
        topic = availability.topic
        subject = topic.subject
        {
          id: meet.id,
          date: meet.date_time,
          status: meet.status,
          description: meet.description,
          interesteds: meet.count_interesteds,
          topic: {
            id: topic.id,
            name: topic.name,
            image_url: topic.image_url
          },
          subject: {
            id: subject.id,
            name: subject.name
          },
          tutor: {
            name: @current_user.first.name
          }
        }
      end

    # Find the AvailabilityTutor based on the ID in the URL
    def set_availability_tutor
      @availability_tutor = AvailabilityTutor.find(params[:tutor_availability_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("error.availabilities.not_found") }, status: :not_found
    end

    def set_meet
      @meet = Meet.find(params[:idReunion])
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("error.meets.not_found") }, status: :not_found
    end

    def map_meeting_status(status_param)
      case status_param.to_i
      when 0
          "pending"
      when 1
          "confirmed"
      when 2
          "completed"
      when 3
          "cancelled"
      else
          nil
      end
    end
end
