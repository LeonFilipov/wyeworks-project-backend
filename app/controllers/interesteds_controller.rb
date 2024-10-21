class InterestedsController < ApplicationController
    before_action :set_availability_tutor, only: [ :create, :destroy ]

    # GET /tutor_availability/:tutor_availability_id/interesteds
    def index
        # Fetch all users interested in the specified availability tutor and return only the user_id and tutor_availability_id
        interesteds = Interested.where(availability_tutor_id: params[:tutor_availability_id])
        render json: interesteds.as_json(only: [ :user_id, :tutor_availability_id ])
    end

    # # POST /availability_tutors/:tutor_availability_id/interesteds
    # def create
    #   # Add an AvailabilityTutor to the current user's interested list
    #   if @current_user.interested_availability_tutors << @availability_tutor
    #     render json: { message: "Interest added successfully" }, status: :created
    #   else
    #     render json: { errors: "Unable to add interest" }, status: :unprocessable_entity
    #   end
    # end

    # DELETE /interesteds/:tutor_availability_id
    def destroy
      # Remove an AvailabilityTutor from the current user's interested list
      if @current_user.interested_availability_tutors.destroy(@availability_tutor)
        render json: { message: "Interest removed successfully" }, status: :ok
      else
        render json: { errors: "Unable to remove interest" }, status: :unprocessable_entity
      end
    end

    private

    def set_availability_tutor
      @availability_tutor = AvailabilityTutor.find(params[:tutor_availability_id])
    end
end
