#
class JsonWebTokenService
    def self.encode(payload, exp = 2.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, ENV["JWT_SECRET"])
    end

    def self.decode(token)
        decoded = JWT.decode(token, ENV["JWT_SECRET"])[0]
        HashWithIndifferentAccess.new decoded
    end
end
