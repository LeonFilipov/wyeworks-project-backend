class TopicsService
  def initialize(current_user)
    @current_user = current_user
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
