class TopicsService
  def initialize(current_user)
    @current_user = current_user
  end

  def get_topics_by_id(id)
    begin
      query = AvailabilityTutor.joins("INNER JOIN users ON users.id = availability_tutors.user_id")
                                  .joins("INNER JOIN topics ON topics.id = availability_tutors.topic_id")
                                  .joins("LEFT JOIN meets ON meets.availability_tutor_id = availability_tutors.id")
                                  .select("topics.name AS topic_name,
                                           topics.description AS topic_description,
                                           users.id AS tutor_id,
                                           meets.id AS meet_id,
                                           meets.status AS meet_status,
                                           meets.date_time AS meet_date")
                                  .where(topics: { id: id })

      formatted_data = query.map do |record|
        {
          name: record.topic_name,
          description: record.topic_description,
          proposed: record.tutor_id == @current_user.first.id,
          meets: [
            {
              id: record.meet_id,
              status: record.meet_status,
              date: record.meet_date
            }
          ]
        }
      end
      formatted_data
    rescue ActiveRecord::RecordNotFound
      { error: I18n.t("error.topics.not_found") }
    end
  end

  def self.get_topic_owner(topic_id)
    begin
      query = AvailabilityTutor.joins("INNER JOIN users ON users.id = availability_tutors.user_id")
                              .joins("INNER JOIN topics ON topics.id = availability_tutors.topic_id")
                              .select("users.id AS tutor_id")
                              .where(topics: { id: topic_id })
      result = query.map do |record|
        record.tutor_id
      end
      result
    rescue ActiveRecord::RecordNotFound
      { error: I18n.t("error.topics.not_found") }
    end
  end
end
