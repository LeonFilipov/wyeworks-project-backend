require 'rails_helper'

RSpec.describe "UsersControllers", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }
  describe "GET /profile" do
    it "returns the current user with correct attributes" do
      get "/profile", headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).keys).to eq([ "id", "name", "email", "description", "image_url", "career" ])
      expect(JSON.parse(response.body)["name"]).to eq(user.name)
    end

    it "returns an error if the token is invalid" do
      get "/profile", headers: { "Authorization" => "invalid_token" }
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({ "error" => I18n.t("error.sessions.invalid_token") })
    end

    it "returns an error if the token is missing" do
      get "/profile"
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq({ "error" => I18n.t("error.sessions.missing_header") })
    end
  end

  describe "PUT /update" do
    it "updates the current user with the correct attributes and ignore non permited attributes" do
      put "/profile", params: { user: {
        name: "Juan Pablo II",
        description: "new description",
        non_permited_attribute: "non-editable",
        email: "non-editable" }
      },
      headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({ "message" => I18n.t("success.users.updated") })
    end
  end
end
