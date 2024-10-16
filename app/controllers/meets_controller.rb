class MeetsController < ApplicationController
    before_action :set_availability_tutor, only: [ :index ]
    before_action :set_meet, only: [ :show ]

    # GET /availability_tutors/:availability_tutor_id/meets
    def index
      # Return all meetings associated with a specific availability tutor
      @meets = @availability_tutor.meets
      render json: @meets, status: :ok
    end

    # GET /meets/:id
    def show
      # Return a specific meeting's details
      render json: @meet, status: :ok
    end

    # Find the AvailabilityTutor based on the ID in the URL
    def set_availability_tutor
      @availability_tutor = AvailabilityTutor.find(params[:tutor_availability_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Availability tutor not found" }, status: :not_found
    end

    def set_meet
      @meet = Meet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Meet not found" }, status: :not_found
    end

    def available_meets
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
          meets = meets.joins(:participants).where(participants: { user_id: @current_user.id })
        else
          meets = meets.where.not(id: meets.joins(:participants).where(participants: { user_id: @current_user.id }))
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
          tutor_name: meet.availability_tutor.user.name,
          meeting_date: meet.date_time,
          meet_status: meet.status,
          subject: {
            id: subject.id,
            name: subject.name
          },
          interested: meet.users.include?(@current_user),
          number_of_interested: meet.users.size
        }
      end

      render json: meets_data, status: :ok
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
    # GET /profile/meets/:id
    def my_meet
      meet = Meet.find_by(id: params[:id])
      if meet.nil? || meet.availability_tutor.user_id != @current_user.first.id # Verifica si la reunión pertenece al usuario
        render json: { error: "Meet not found" }, status: :not_found # 404
        return
      end
      render json: format_meet(meet), status: :ok
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

      def map_meeting_status(status_param)
        case status_param.to_i
        when 0
          "pending"
        when 1
          "confirmed"
        when 2
          "completed"
        when 3
          "canceled"
        else
          nil
        end
      end
end
