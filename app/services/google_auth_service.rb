class GoogleAuthService
  include HTTParty

  def self.get_access_token(code)
    response = HTTParty.post("https://oauth2.googleapis.com/token", body: {
      code: code,
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      redirect_uri: ENV["GOOGLE_REDIRECT_URI"],
      grant_type: "authorization_code"
    }.to_json, headers: {
      "Content-Type" => "application/json"  
    })

    if response.success?
      return response
    else
      return "Error getting access token #{response.parsed_response}"
    end
  end

  def self.get_user_info(access_token)
    response = HTTParty.get("https://www.googleapis.com/oauth2/v3/userinfo", 
      query: { "access_token" => access_token }    
    )

    if response.success?
      return response.parsed_response
    else
      raise "Error getting user info: #{response.parsed_response}"
    end
  end
end
