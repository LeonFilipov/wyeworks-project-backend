class StudentsService
    def initialize(current_user)
      @current_user=current_user
    end

    def get_my_requested_topics
      query = StudentTopic.joins(:user)
                          .joins(:topic)
                          .joins(topic: :subject)
                          .select("subjects.id as subject_id, subjects.name as subject_name, student_topics.topic_id, topics.name as topic_name")
                          .where(user_id: @current_user.first.id)

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

    def get_my_interested_meetings
        query=Meet.joins("INNER JOIN availability_tutors ON availability_tutors.id = meets.availability_tutor_id")
        .joins("INNER JOIN participants ON participants.meet_id = meets.id")
        .joins("INNER JOIN users ON availability_tutors.user_id = users.id")
        .joins("INNER JOIN topics ON availability_tutors.topic_id = topics.id")
        .select("topics.name AS topic_name,
               users.name AS tutor_name,
               meets.status,
               meets.date_time AS date_time")
        .where(participants: { user_id: @current_user.first.id })

        result = query.map do |record|
          {
            topic_name: record.topic_name,
            tutor_name: record.tutor_name,
            meet_status: record.status,
            date_time: record.date_time.nil? ? "Indefinida" : record.date_time
          }
        end
        result
    rescue ActiveRecord::RecordNotFound
      { error: "Intereted meetings not found" }
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
