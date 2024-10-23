class MeetsService
    def initialize(current_user)
        @current_user=current_user
    end

    def self.date_check
        Meet.mark_finished_meets
    end
end
