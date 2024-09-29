class AvailabilityTutorsController < ApplicationController
  # GET /universities/:university_id/subjects/:subject_id/topics/:topic_id/tutor_availability
  # GET /tutor_availability
  def index
    if params[:topic_id]
      @availabilities = AvailabilityTutor.where(topic_id: params[:topic_id])
    else
      @availabilities = AvailabilityTutor.all
    end
  
    render json: @availabilities.as_json(
      only: [:id, :description, :date_from, :date_to, :link],
      include: { tentatives: { only: [:day, :schedule_from, :schedule_to] } }
    )
  end

  # GET /universities/:university_id/subjects/:subject_id/topics/:topic_id/tutor_availability/:id
  # GET /tutor_availability/:id
  def show
    @availability = AvailabilityTutor.find(params[:id])

    render json: @availability.as_json(only: [ :id, :description, :date_from, :date_to, :link ])
  end

  # POST /universities/:university_id/subjects/:subject_id/topics/:topic_id/tutor_availability
  # POST /tutor_availability
  def create
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
    else
      @topic = Topic.new(topic_params)
      unless @topic.save
        render json: { errors: @topic.errors.full_messages }, status: :unprocessable_entity
        return
      end
    end
  
    # Initialize the AvailabilityTutor without tentatives first
    @availability = @topic.availability_tutors.new(availability_tutor_params.except(:tentatives))
    @availability.user = @current_user
  
    # Check if tentatives are provided
    if availability_tutor_params[:tentatives].blank?
      render json: { errors: "At least one tentative schedule is required." }, status: :unprocessable_entity
      return
    end
  
    if @availability.save
      # Process tentatives
      tentatives_data = availability_tutor_params[:tentatives].map do |tentative|
        @availability.tentatives.new(tentative.permit(:day, :schedule_from, :schedule_to))
      end
  
      if tentatives_data.count > 7
        render json: { errors: "Cannot create more than 7 tentatives for an availability" }, status: :unprocessable_entity
        return
      end
  
      if tentatives_data.map(&:save).all?
        render json: { message: "Availability and tentatives created successfully", availability: @availability, tentatives: @availability.tentatives }, status: :created
      else
        render json: { errors: @availability.errors.full_messages + @availability.tentatives.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: @availability.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :asset, :subject_id)
  end

  def availability_tutor_params
    params.require(:availability_tutor).permit(:description, :date_from, :date_to, :link, tentatives: [:day, :schedule_from, :schedule_to])
  end
end
