class MeetsService
    def initialize(meet = nil, user = nil)
      @meet = meet
      @user = user
    end
  
    # Class method to mark finished meets based on date
    def self.date_check
      Meet.mark_finished_meets
    end
  
    # Fetches meets for a user by status
    def self.user_meets_by_status(user, status)
      user.meets.where(status: status)
    end
  
    def self.user_confirmed_meets(user)
      user_meets_by_status(user, 'confirmed')
    end
  
    def self.user_pending_meets(user)
      user_meets_by_status(user, 'pending')
    end
  
    def self.user_finished_meets(user)
      user_meets_by_status(user, 'finished')
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
                          meets.description AS description,
                          meets.status AS status,
                          meets.date_time AS date_time")
                  .where(meets: { id: @meet.id })
      query
    rescue ActiveRecord::RecordNotFound
      { error: "Participants not found" }
    end
  end