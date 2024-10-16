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
      only: [ :id, :description, :link, :availability ],
      include: {
        topic: { only: [ :id, :name, :subject_id ] }
        # tentatives: { only: [ :day, :schedule_from, :schedule_to ] }
      }
    )
  end

  # GET /universities/:university_id/subjects/:subject_id/topics/:topic_id/tutor_availability/:id
  # GET /tutor_availability/:id
  def show
    @availability = AvailabilityTutor.find(params[:id])

    render json: @availability.as_json(
      only: [ :id, :description, :link, :availability ],
      include: { topic: { only: [ :id, :name, :subject_id ] } }
    )
  end

  # POST /universities/:university_id/subjects/:subject_id/topics/:topic_id/tutor_availability
  # POST /tutor_availability
  def create
    @topic = Topic.new(topic_params)
    begin
      @topic.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: @topic.errors.full_messages }, status: :unprocessable_entity
      return
    end
    # Create availability
    @availability = @topic.availability_tutors.new(availability_tutor_params)
    # Get the current user
    @availability.user = @current_user.first
    # Try to save availability
    if @availability.save
      render json: {
        message: "Topic and availability created successfully"
      }, status: :created
    else
      render json: { errors: @availability.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST tutor_availability/:id/intersteds
  def add_interest
    @availability = AvailabilityTutor.find(params[:id])
    debug_messages = []  # Array para almacenar mensajes de depuración

    # Verificar si el usuario ya expresó interés en una meet actual en estado 'pending'
    pending_meet = @availability.meets.find_by(status: "pending")
    debug_messages << "Found pending meet: #{pending_meet.present?}"

    if pending_meet
      # Verificar si el usuario ya está interesado en la meet actual en estado 'pending'
      pending_meet_interest = pending_meet.interesteds.exists?(user_id: @current_user.first.id)
      debug_messages << "User interested in current pending meet: #{pending_meet_interest}"

      if pending_meet_interest
        render json: { message: "You have already expressed interest in the current pending meet.", debug: debug_messages }, status: :unprocessable_entity
        return
      end
    end

    # Verificar si el usuario ya expresó interés en esta disponibilidad
    existing_interest = Interested.find_by(user: @current_user.first, availability_tutor: @availability)
    debug_messages << "User has existing interest: #{existing_interest.present?}"

    unless existing_interest
      Interested.create!(user: @current_user.first, availability_tutor: @availability)
      debug_messages << "User's interest added to availability tutor."
    end

    # Verificar si ya existe una reunión en estado 'pending'
    pending_meet = @availability.meets.find_by(status: "pending")

    def add_interest
    @availability = AvailabilityTutor.find(params[:id])
    debug_messages = []  # Array para almacenar mensajes de depuración

    # Verificar si el usuario ya expresó interés en una meet actual en estado 'pending'
    pending_meet = @availability.meets.find_by(status: "pending")
    debug_messages << "Found pending meet: #{pending_meet.present?}"

    if pending_meet
      # Verificar si el usuario ya está interesado en la meet actual en estado 'pending'
      pending_meet_interest = pending_meet.interesteds.exists?(user_id: @current_user.first.id)
      debug_messages << "User interested in current pending meet: #{pending_meet_interest}"

      if pending_meet_interest
        render json: { message: "You have already expressed interest in the current pending meet.", debug: debug_messages }, status: :unprocessable_entity
        return
      end
    end

    # Verificar si el usuario ya expresó interés en esta disponibilidad
    existing_interest = Interested.find_by(user: @current_user.first, availability_tutor: @availability)
    debug_messages << "User has existing interest: #{existing_interest.present?}"

    unless existing_interest
      Interested.create!(user: @current_user.first, availability_tutor: @availability)
      debug_messages << "User's interest added to availability tutor."
    end

    # Verificar si ya existe una reunión en estado 'pending'
    pending_meet = @availability.meets.find_by(status: "pending")

    if pending_meet.nil?
      @meet = @availability.meets.new(
        description: "Meeting for #{@availability.description}",
        link: "https://meeting-link.com",
        mode: "virtual",
        status: "pending",
        date_time: nil,  # Empty date_time field
        count_interesteds: 1  # Initialize with 1 interested
      )
  
      if @meet.save
        Participant.create!(meet: @meet, user: @current_user.first)
        debug_messages << "New meet created successfully, and user added as participant."
        render json: { message: "Interest added and meet created", meet: @meet, debug: debug_messages }, status: :created
      else
        debug_messages << "Failed to create meet: #{@meet.errors.full_messages.join(', ')}"
        render json: { message: "Interest added but failed to create meet", errors: @meet.errors.full_messages, debug: debug_messages }, status: :unprocessable_entity
      end
    else
      pending_meet.increment!(:count_interesteds)
      debug_messages << "Incremented count_interesteds for existing meet."
  
      unless pending_meet.participants.exists?(user_id: @current_user.first.id)
        Participant.create!(meet: pending_meet, user: @current_user.first)
        debug_messages << "User added as participant to existing pending meet."
      end
  
      render json: { message: "Interest added, and meet updated", meet: pending_meet, debug: debug_messages }, status: :ok
    end
  end

# PATCH /meets/:id
def update_meet
  @meet = Meet.find(params[:id])

  if @meet.update(date_time: params[:date_time])
    render json: { message: "Meet updated successfully", meet: @meet }, status: :ok
  else
    render json: { errors: @meet.errors.full_messages }, status: :unprocessable_entity
  end
end


  private
    def topic_params
      params.require(:topic).permit(:name, :description, :image_url, :subject_id)
    end

    def availability_tutor_params
      params.require(:availability_tutor).permit(:availability, :description, :link)
    end
end
