class StudentsController < UsersController
    before_action :set_subject, only: [ :request_topic ]
    before_action :set_topic, only: [ :request_topic ]

    def request_topic
        @topic.users << @current_user
        if @topic.save
            render json: { message: "Student successfully added to topic" }, status: :ok
        else
            render json: { error: "Failed to add student to topic" }, status: :unprocessable_entity
        end
    end

    def show_my_requested_topics
        query = StudentTopic.joins(:user).joins(:topic).joins(topic: :subject)
                            .select("subjects.id as subject_id, subjects.name as subject_name, student_topics.topic_id, topics.name as topic_name")
                            .where(user_id: @current_user.id)
        result = query.map do |record|
            {
                subject_id: record.subject_id,
                subject_name: record.subject_name,
                topic_id: record.topic_id,
                topic_name: record.topic_name
            }
            end
        render json: result, status: :ok
    end

    def show_requested_topics
        query = StudentTopic.joins(:user).joins(:topic).joins(topic: :subject)
                            .select("student_topics.topic_id, topics.name as topic_name, subjects.id as subject_id, subjects.name as subject_name, users.id as user_id")

        topics = {}
        query.each do |record|
            topic_id = record.topic_id
            topic_name = record.topic_name
            subject_id = record.subject_id
            subject_name = record.subject_name

            topics[topic_id] ||= { topic_name: topic_name, subject_id: subject_id, subject_name: subject_name, user_count: 0 }
            topics[topic_id][:user_count] += 1
        end

        result = topics.map do |topic_id, data|
            {
                subject_id: data[:subject_id],
                subject_name: data[:subject_name],
                topic_id: topic_id,
                topic_name: data[:topic_name],
                user_count: data[:user_count]
            }
        end

        render json: result, status: :ok
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
            @topic = @subject.topics.find(params[:topic_id])
        rescue ActiveRecord::RecordNotFound
            render json: { error: "Topic not found" }, status: :not_found
        end

        # Permit only allowed parameters
        def solicitar_params
            params.require(:solicitar).permit(:subject_id, :topic_id)
        end
end
