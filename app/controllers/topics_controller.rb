class TopicsController < ApplicationController
  before_action :set_subject
  before_action :set_topic, only: [ :show, :update, :destroy ]

  # GET /universities/:university_id/subjects/:subject_id/topics
  def index
    @topics = @subject.topics
    render json: @topics, status: :ok
  end

  # GET /universities/:university_id/subjects/:subject_id/topics/:id
  def show
    render json: @topic, status: :ok
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
    params.require(:topic).permit(:name, :asset)
  end
end
