class MeetsService
    def self.date_check
        Meet.mark_finished_meets
    end
end
