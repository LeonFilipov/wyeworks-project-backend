class MeetsService
    def initialize(meet = nil, user = nil)
      @meet = meet
      @user = user
    end

    def self.create_pending_meet(meet_params)
      if Meet.exists?(availability_tutor_id: meet_params[:availability_tutor_id], status: "pending")
        return
      end
      Meet.create!(meet_params)
    end

    # Class method to mark finished meets based on date
    def self.date_check
      Meet.mark_finished_meets
    end

    def self.student_meets_by_status(user, status)
      Meet.joins(:participants)
          .where(participants: { user_id: user.id })
          .where(status: status)
    end

    def self.tutor_meets_by_status(user, status)
      meets_query = Meet.joins(:availability_tutor)
                        .where(availability_tutors: { user_id: user.id })
      meets_query = meets_query.where(status: status) if status
      meets_query
    end

    # Retrieves participants and topic details for a specific meet
    def get_participants_and_topic
      query = Meet.joins("INNER JOIN availability_tutors ON availability_tutors.id = meets.availability_tutor_id")
                  .joins("INNER JOIN topics ON availability_tutors.topic_id = topics.id")
                  .joins("INNER JOIN participants ON meets.id = participants.meet_id")
                  .joins("INNER JOIN users ON participants.user_id = users.id")
                  .select("users.name AS participant_name,
                          users.email AS participant_email,
                          topics.name AS topic_name,
                          topics.description AS description,
                          meets.status AS status,
                          meets.date_time AS date_time")
                  .where(meets: { id: @meet.id })
      query
    rescue ActiveRecord::RecordNotFound
      { error: "Participants not found" }
    end
end
