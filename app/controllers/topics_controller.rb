class TopicsController < ApplicationController
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
    render json: { message: "to do"}, status: :ok
  end

  # POST /topics
  def create
    begin
      topic = Topic.create!(topic_params)
      AvailabilityTutor.create!(user_id: @current_user.first.id, topic_id: topic.id)
      render json: { message: I18n.t("success.topics.created")}, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # DELETE /topics/:id
  def delete
    topic = Topic.find_by(id: params[:id])
    if topic.nil?
      render json: { error: I18n.t("error.topics.not_found") }, status: :not_found
    elsif topic.user_id != @current_user.first.id
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

  private
    def topic_params
      params.require(:topic).permit(:name, :description, :link, :show_email, :subject_id)
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
end
