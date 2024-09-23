class StudentsService
    def initialize(current_user)
      @current_user=current_user
    end
  
    def get_my_requested_topics()
        query = StudentTopic.joins(:user)
                          .joins(:topic)
                          .joins(:subject)
                          .select("subjects.id as subject_id, subjects.name as subject_name, student_topics.topic_id, topics.name as topic_name")
                          .where(user_id: @current_user.select[:id])
      
    result = query.map do |record|
        {
          subject_id: record.subject_id,
          subject_name: record.subject_name,
          topic_id: record.topic_id,
          topic_name: record.topic_name
        }
      end
  
      result
    rescue ActiveRecord::RecordNotFound
      { error: "Requested topics not found" }
    end



    def self.get_requested_topics
        query = StudentTopic.joins(:user)
                            .joins(:topic)
                            .joins(topic: :subject)
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

        result
      rescue ActiveRecord::RecordNotFound
        { error: "Requested topics not found" }
      end



  end
  