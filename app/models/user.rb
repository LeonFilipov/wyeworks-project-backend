class User < ApplicationRecord
    def self.google_auth(auth)
        where(email: auth.info.email).first_or_initialize do |user|
            user.name = auth.info.name
            user.email = auth.info.email
            user.uid = auth.uid
            user.provider = auth.provider
        end
    end
end
