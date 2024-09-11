class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :uid , presence: true, uniqueness: true

    def self.google_auth(user_info)
        where(email: user_info["email"]).first_or_initialize do |user|
            user.name = user_info["name"]
            user.email = user_info["email"]
            user.uid = user_info["sub"]
            user.description = ""
            user.image_url = user_info["picture"]
        end
    end
end
