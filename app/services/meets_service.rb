class MeetsService
    def initialize(meet)
        @meet = meet
    end

    def self.date_check
        Meet.mark_finished_meets
    end

    def get_participants_and_topic
        query=Meet.joins("INNER JOIN availability_tutors ON availability_tutors.id = meets.availability_tutor_id")
        .joins("INNER JOIN topics ON availability_tutors.topic_id = topics.id")
        .joins("INNER JOIN participants ON meets.id = participants.meet_id")
        .joins("INNER JOIN users ON participants.user_id = users.id")
        .select("users.name AS participant_name,
                users.email AS participant_email,
                topics.name AS topic_name,
                meets.description AS description,
                meets.status AS status,
                meets.date_time AS date_time")
                .where(meets: { id: @meet.id })
        query
    rescue ActiveRecord::RecordNotFound
        { error: "Participants not found" }
    end
end
