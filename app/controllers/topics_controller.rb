class TopicsController < ApplicationController
  before_action :set_subject, only: [ :index, :create, :show, :update, :destroy ]
  before_action :set_topic, only: [ :show, :update, :destroy ]

  # GET /universities/:university_id/subjects/:subject_id/topics
  def index
    @topics = @subject.topics
    render json: @topics.as_json(only: [ :id, :name, :description ], methods: [ :subject_id ]), status: :ok
  end

  # GET /universities/:university_id/subjects/:subject_id/topics/:id
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
      link: latest_availability&.link,
    }
  end
end
