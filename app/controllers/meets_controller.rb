class MeetsController < ApplicationController
    before_action :set_availability_tutor, only: [ :index ]
    before_action :set_meet, only: [ :show, :confirm_pending_meet ]
    before_action :set_date, only: [ :confirm_pending_meet ]

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

    # POST /meets/:id
    def confirm_pending_meet 
      @availability_tutor = AvailabilityTutor.find(@meet.availability_tutor_id)
      if @current_user.first.id != @availability_tutor.user_id
        render json: { error: "User not allowed" }, status: :unauthorized
      elsif @meet.status != "pending"
        render json: { error: "Meet already confirmed" }, status: :bad_request
      else
        @meet.status = "confirmed"
        @meet.date_time = params[:meet][:date]
        @meet.save
        render json: { message: "Meet confirmed successfully" }, status: :ok
      end
    end

    private

    # Find the AvailabilityTutor based on the ID in the URL
    def set_availability_tutor
      @availability_tutor = AvailabilityTutor.find(params[:tutor_availability_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Availability tutor not found" }, status: :not_found
    end

    # Find the Meet based on the ID in the URL
    def set_meet
      @meet = Meet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Meet not found" }, status: :not_found
    end

    # Find the date in timestamp in the URL
    def set_date
      @dateTS = params.require(:meet).permit[:date]
    end
end
