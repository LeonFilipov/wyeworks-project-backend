class InterestedsController < ApplicationController
    before_action :set_availability_tutor, only: [ :index ]

    # GET /tutor_availability/:tutor_availability_id/interesteds
    def index
        # Fetch all users interested in the specified availability tutor and return only the user_id and tutor_availability_id
        interesteds = Interested.where(availability_tutor_id: params[:tutor_availability_id])
        render json: interesteds.as_json(only: [ :user_id, :tutor_availability_id ])
    end

    # # DELETE /interesteds/:tutor_availability_id
    # def destroy
    #   # Remove an AvailabilityTutor from the current user's interested list
    #   if @current_user.interested_availability_tutors.destroy(@availability_tutor)
    #     render json: { message: "Interest removed successfully" }, status: :ok
    #   else
    #     render json: { errors: "Unable to remove interest" }, status: :unprocessable_entity
    #   end
    # end

    private

    def set_availability_tutor
      @availability_tutor = AvailabilityTutor.find(params[:tutor_availability_id])
    end
end
