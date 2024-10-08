class TopicsController < ApplicationController
  before_action :set_subject, only: [:create, :show, :update, :destroy ]
  before_action :set_topic, only: [ :show, :update, :destroy ]

  # GET /topics
  def index
    # Filtro inicial
    availability_tutors = AvailabilityTutor.all

    # Filtrar por user_id si está presente
    availability_tutors = availability_tutors.where(user_id: params[:user_id]) if params[:user_id].present?

    # Filtrar por topic_id si subject_id está presente
    if params[:subject_id].present?
      topics_by_subject = Topic.where(subject_id: params[:subject_id]).pluck(:id)
      availability_tutors = availability_tutors.where(topic_id: topics_by_subject)
    end

    render json: format_topic_response(availability_tutors), status: :ok
  end

  # GET /topics/:id
  def show
    render json: @topic.as_json(only: [ :id, :name, :description ], methods: [ :subject_id ]), status: :ok
  end

  # GET /users/:user_id/proposed_topics
  def proposed_topics
    @user = User.find(params[:id])
    @tutor_availability = AvailabilityTutor.where(user_id: @user.id)
    @topics = @tutor_availability.map(&:topic)
    @interesteds = Interested.where(availability_tutor_id: @tutor_availability.map(&:id))
    @topics_count = @topics.count { |topic| topic.availability_tutors.any? { |availability| availability.interesteds.exists? } }
    render json: @topics.map { |topic| format_proposed_topic(topic) }, status: :ok
  end

  # GET /users/:user_id/proposed_topics/:topic_id
  def proposed_topic
    # Encuentra el usuario primero (opcional, dependiendo de cómo quieras estructurarlo)
    @user = User.find(params[:id])

    # Encuentra el topic por el ID proporcionado
    @topic = @user.topics.find_by(id: params[:topic_id]) # Cambia params[:id] a params[:topic_id]

    # Manejo de error si no se encuentra el topic
    if @topic.nil?
      render json: { error: "Topic not found" }, status: :not_found
    else
      render json: format_detailed_proposed_topic(@topic), status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  # POST /universities/:university_id/subjects/:subject_id/topics
  def create
    @topic = @subject.topics.build(topic_params)
    if @topic.save
      render json: @topic, status: :created
    else
      render json: @topic.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /universities/:university_id/subjects/:subject_id/topics/:id
  def update
    if @topic.update(topic_params)
      render json: @topic, status: :ok
    else
      render json: @topic.errors, status: :unprocessable_entity
    end
  end

  # DELETE /universities/:university_id/subjects/:subject_id/topics/:id
  def destroy
    @topic.destroy
    head :no_content
  end

  private

  # Set the subject based on the university and subject ID
  def set_subject
    @subject = Subject.find(params[:subject_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Subject not found" }, status: :not_found
  end

  # Set the topic within the context of the subject
  def set_topic
    @topic = @subject.topics.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Topic not found" }, status: :not_found
  end

  # Permit only allowed parameters
  def topic_params
    params.require(:topic).permit(:name, :description)
  end

  def format_topic_response(availability_tutors)
  availability_tutors.map do |availability_tutor|
    topic = availability_tutor.topic
    user = availability_tutor.user
    subject = topic.subject

    {
      availability_id: availability_tutor.id,
      topic_name: topic.name,
      topic_image: topic.image_url,
      availability: availability_tutor.availability,
      interesteds: availability_tutor.interesteds.count,
      subject: {
        id: subject.id,
        name: subject.name,
      },
      tutor: {
        id: user.id,
        name: user.name
      }

    }
  end
end

  # Format the topic for the proposed_topics endpoint
  def format_proposed_topic(topic)
    {
      idsubject: topic.subject.id,
      namesubject: topic.subject.name,
      idtopic: topic.id,
      nametopic: topic.name,
      nombretutor: topic.availability_tutors.last&.user&.name, # Obtenemos el nombre del usuario asociado al último availability_tutor
      cantidadInteresados: topic.availability_tutors.sum { |availability| availability.interesteds.count }
    }
  end

  # Format the topic for the proposed_topic details endpoint
  def format_detailed_proposed_topic(topic)
    latest_availability = topic.availability_tutors.last
    {
      idtopic: topic.id,
      nametopic: topic.name,
      descripcionTopic: topic.description,
      descripciondisponibilidad: latest_availability&.description,
      link: latest_availability&.link
    }
  end
end
