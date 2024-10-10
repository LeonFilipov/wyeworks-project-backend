class StudentsController < UsersController
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
        service = StudentsService.new(@current_user)
        result = service.get_my_requested_topics()

        if result.is_a?(Hash)
            render json: result, status: :not_found
        else
            render json: result, status: :ok
        end
    end

    def requested_topics
        result = StudentsService.get_requested_topics

        if result.is_a?(Hash)
            render json: result, status: :not_found
        else
            render json: result, status: :ok
        end
    end

    def interested_meetings
        service=StudentsService.new(@current_user)
        meetings=service.get_my_interested_meetings

        if result.is_a?(Hash)
            render json: result, status: :not_found
        else
            render json: result, status: :ok
        end
    
    end

    private
        # Set the topic within the context of the subject
        def set_topic
            @topic = Topic.find(params[:topic_id])
        rescue ActiveRecord::RecordNotFound
            @topic = Topic.new(topic_params)
            unless @topic.save
                render json: { errors: @topic.errors.full_messages }, status: :unprocessable_entity
            nil
            end
        end

        # Permit only allowed parameters
        def solicitar_params
            params.require(:solicitar).permit(:topic_id)
        end

        def topic_params
            params.require(:topic).permit(:name, :description, :subject_id)
        end
end
