class TopicsController < ApplicationController
  before_action :topic_params_edit, only: [ :update ]

  # GET /topics
  def index
    # Filtro inicial
    topics = Topic.all
    # Filtrar por user_id si está presente
    if params[:user_id].present?
      topics = topics.for_user(params[:user_id])
    end
    if params[:subject_id].present?
      topics = topics.where(subject_id: params[:subject_id])
    end

    render json: topic_response(topics), status: :ok
  end

  # GET /topics/:id
  def show
    topic = Topic.find_by(id: params[:id])
    if topic.nil?
      render json: { error: I18n.t("error.topics.not_found") }, status: :not_found
    else
      MeetsService.create_pending_meet({ availability_tutor_id: topic.availability_tutor.id, link: topic.link, status: "pending" })
      render json: topic_details(topic), status: :ok
    end
  end

  # POST /topics
  def create
    begin
      existing_topic = Topic.joins(:availability_tutor).where(
        name: topic_params[:name],
        availability_tutors: { user_id: @current_user.first.id }
      ).first

      if existing_topic
        render json: { error: "You already have a topic with this name" }, status: :unprocessable_entity
        return
      end

      topic = Topic.create!(topic_params)
      availability = AvailabilityTutor.create!(user_id: @current_user.first.id, topic_id: topic.id)
      MeetsService.create_pending_meet({ availability_tutor_id: availability.id, link: topic.link, status: "pending" })
      render json: { message: I18n.t("success.topics.created"), topic: { id: topic.id } }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # DELETE /topics/:id
  def delete
    topic = Topic.find_by(id: params[:id])
    if topic.nil?
      render json: { error: I18n.t("error.topics.not_found") }, status: :not_found
    elsif topic.tutor.id != @current_user.first.id
      render json: { error: I18n.t("error.users.not_allowed") }, status: :unauthorized
    else
      topic.destroy
      render json: { message: I18n.t("success.topics.deleted") }, status: :ok
    end
  end

  # GET /proposed_topics
  def proposed_topics
    topics = Topic.all
    topics = topics.for_user(@current_user.first.id)
    render json: topic_response(topics), status: :ok
  end

  # GET /users/:id/proposed_topics_given_user
  def proposed_topics_given_user
    user = User.find_by(id: params[:id])
    return render json: { error: I18n.t("error.users.not_found") }, status: :not_found unless user

    topics = Topic.for_user(user.id)
    render json: topic_response(topics), status: :ok
  end

  # PATCH /topics/:id
  def update
    topic = Topic.find_by(id: params[:id])
    owner = TopicsService.get_topic_owner(params[:id])
    if topic.nil?
      render json: { error: I18n.t("error.topics.not_found") }, status: :not_found
    elsif owner.nil?
      render json: { error: I18n.t("error.topics.not_found") }, status: :not_found
    elsif owner.first != @current_user.first.id
      render json: { error: I18n.t("error.users.not_allowed") }, status: :unauthorized
    else
      topic.update(topic_params_edit)
      render json: { message: I18n.t("success.topics.updated") }, status: :ok
    end
  end

  private
    def topic_params
      params.require(:topic).permit(:name, :description, :link, :show_email, :subject_id)
    end

    def topic_params_edit
      params.require(:topic).permit(:name, :description, :link, :show_email)
    end

    def topic_response(topics)
      topics.map do |topic|
        tutor = topic.tutor
        {
          id: topic.id,
          name: topic.name
        }
      end
    end

    def topic_details(topic)
      availability = topic.availability_tutor
      meets = availability.meets
      tutor = topic.tutor
      {
        name: topic.name,
        description: topic.description,
        link: topic.link,
        show_email: topic.show_email,
        subject_id: topic.subject_id,
        proposed: availability.user_id == @current_user.first.id,
        tutor: {
          id: tutor.id,
          name: tutor.name,
          email: if topic.show_email then tutor.email else nil end
        },
        meets: meets.map do |meet|
          {
            id: meet.id,
            status: meet.status,
            date: meet.date_time
          }
        end
      }
    end
end
