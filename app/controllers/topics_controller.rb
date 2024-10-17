class TopicsController < ApplicationController
  before_action :set_subject, only: [ :create, :show, :update, :destroy ]
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
    availability_tutors = availability_tutors.
                          left_joins(:interesteds).
                          select("availability_tutors.*, COUNT(interesteds.id) AS interested_count").
                          group("availability_tutors.id").
                          order(Arel.sql("MAX(CASE WHEN interesteds.user_id = '#{ActiveRecord::Base.connection.quote_string(@current_user.first.id)}' THEN 1 ELSE 0 END) DESC, availability_tutors.created_at DESC"))

    render json: format_topic_response(availability_tutors), status: :ok
  end

  # GET /topics/:id
  def show
    render json: @topic.as_json(only: [ :id, :name, :description ], methods: [ :subject_id ]), status: :ok
  end

  # GET /proposed_topics
  def proposed_topics
    tutor_availability = AvailabilityTutor.where(user_id: @current_user.first.id)
    render json: format_topic_response(tutor_availability), status: :ok
  end

  # GET /proposed_topics/:availability_id
  def proposed_topic
    availability = AvailabilityTutor.where(id: params[:availability_id], user_id: @current_user.first.id)
    # Manejo de error si no se encuentra el topic
    if availability.nil?
      render json: { error: "Topic not found" }, status: :not_found
    end
    render json: format_topic_response(availability), status: :ok
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
          topic_description: topic.description,
          availability: availability_tutor.availability,
          availability_description: availability_tutor.description,
          interesteds: availability_tutor.interesteds.count,
          interested: availability_tutor.interesteds.exists?(user_id: @current_user.first.id),
          subject: {
            id: subject.id,
            name: subject.name
          },
          tutor: {
            id: user.id,
            name: user.name
          }
        }
      end
    end
end
