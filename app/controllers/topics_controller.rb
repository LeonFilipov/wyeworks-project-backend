class TopicsController < ApplicationController
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

    render json: format_index_response(availability_tutors), status: :ok
  end
  
  # GET /topics/:id
  def show
    availability_tutor = AvailabilityTutor.find_by(id: params[:id])
    if availability_tutor.nil?
      render json: { error: "Topic not found" }, status: :not_found
    else
      topic_response = format_topic_response(availability_tutor)
      topic_response[:interested_users] = availability_tutor.interested_users.map do |interested|
        {
          id: interested.id,
          name: interested.name,
          image_url: interested.image_url
        }
      end
      render json: topic_response, status: :ok
    end
  end

  # GET /proposed_topics
  def proposed_topics
    tutor_availability = AvailabilityTutor.where(user_id: @current_user.first.id)
    render json: format_index_response(tutor_availability), status: :ok
  end

  # DELETE /proposed_topics/:availability_id
  def destroy_proposed_topic
    availability = AvailabilityTutor.find_by(id: params[:availability_id])
    if availability.nil?
      render json: { error: "Topic not found" }, status: :not_found
    elsif availability.user_id != @current_user.first.id
      render json: { error: "You do not have permission to delete this topic" }, status: :unauthorized
    else
      topic = availability.topic
      topic.destroy
      render json: { message: "Topic deleted successfully" }, status: :ok
    end
  end

  private
    def format_index_response(availability_tutors)
      availability_tutors.map do |availability_tutor|
        format_topic_response(availability_tutor)
      end
    end

    def format_topic_response(availability_tutor)
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
          name: user.name,
          image_url: user.image_url
        }
      }
    end
end
