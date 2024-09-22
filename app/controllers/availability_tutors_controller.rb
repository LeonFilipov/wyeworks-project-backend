class AvailabilityTutorsController < ApplicationController
  def index
    @availability_tutors = AvailabilityTutor.all
    render json: @availability_tutors, status: :ok
  end

  def show
    @availability_tutor = AvailabilityTutor.find(params[:id])
    if @availability_tutor.present?
      render json: @availability_tutor, status: :ok
    else
      render json: { message: "Availability tutor not found" }, status: :not_found
    end
  end

  private
    def user_params
      params.require(:user).permit(:description, :tentative_date_from, :tentative_date_to)
    end
end
