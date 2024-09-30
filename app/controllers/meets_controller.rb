class MeetsController < ApplicationController
    before_action :set_availability_tutor, only: [:index]
    before_action :set_meet, only: [:show]
  
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
end