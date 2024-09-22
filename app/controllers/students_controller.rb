class StudentsController < UsersController
    #before_action :set_subject, only: [ :request_topic ]
    before_action :set_topic, only: [ :request_topic ]

    def request_topic
        @topic.users << @current_user
        if @topic.save
            render json: { message: "Student successfully added to topic" }, status: :ok
        else
            render json: { error: "Failed to add student to topic" }, status: :unprocessable_entity
        end
    end

    def my_requested_topics
        result = StudentsService.get_my_requested_topics(@current_user)

        if result[:error]
            render json: result, status: :not_found
        else
            render json: result, status: :ok
        end
    end

    def all_requested_topics
        result = StudentsService.get_requested_topics

        if result[:error]
            render json: result, status: :not_found
        else
            render json: result, status: :ok
        end
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
