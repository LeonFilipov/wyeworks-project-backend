require 'rails_helper'

RSpec.describe "UsersControllers", type: :request do
  describe "GET /profile" do
    user = FactoryBot.create(:user, name: "Juan Pablo")
    token = JsonWebTokenService.encode(user_id: user.id)
    it "returns the current user with correct attributes" do
      get "/profile", headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).first.keys).to eq(["id", "name", "email", "description", "image_url"])
      expect(JSON.parse(response.body).first["name"]).to eq("Juan Pablo")
    end

    it "returns an error if the token is invalid" do
      get "/profile", headers: { "Authorization" => "invalid_token" }
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({"error" => "Invalid token"})
    end

    it "returns an error if the token is missing" do
      get "/profile"
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq({"error" => "Authorization header is missing"})
    end
  end

  describe "PUT /update" do
    FactoryBot.create(:user, name: "Juan Pablo")
    token = JsonWebTokenService.encode(user_id: 1)
    it "updates the current user with the correct attributes and ignore non permited attributes" do
      put "/profile", params: { user: {
        name: "Juan Pablo II",
        description: "new description",
        non_permited_attribute: "non-editable",
        email: "non-editable" }
      }, 
      headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({"message" => "User updated"})
    end
  end
end
