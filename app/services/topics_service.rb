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


  def self.get_topic_interesteds(id)
    begin
    query=Meet.joins("INNER JOIN availability_tutors ON availability_tutors.id = meets.availability_tutor_id")
              .joins("INNER JOIN topics ON availability_tutors.topic_id = topics.id")
              .joins("INNER JOIN participants ON meets.id = participants.meet_id")
              .joins("INNER JOIN users ON participants.user_id = users.id")
              .select("DISTINCT users.name AS participant_name,
                          users.email AS participant_email,
                          topics.name AS topic_name,
                          topics.description AS description,
                          meets.status AS status,
                          meets.date_time AS date_time")
              .where(topics: { id: id })

      query
    rescue ActiveRecord::RecordNotFound
      { error: I18n.t("error.topics.not_found") }
    end
  end
end
