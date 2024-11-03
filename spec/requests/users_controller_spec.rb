require 'rails_helper'

RSpec.describe "UsersControllers", type: :request do
  let!(:user) { FactoryBot.create(:user, career: nil) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }
  describe "GET /profile" do
    it "returns the current user with correct attributes" do
      get "/profile", headers: { 'Authorization': "Bearer #{token}" }
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

    it "the career is nil if the user does not have a career" do
      get "/profile", headers: { 'Authorization': "Bearer #{token}" }
      expect(JSON.parse(response.body)["career"]).to be_nil
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
      headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({ "message" => I18n.t("success.users.updated") })
      email = user.email
      user.reload
      expect(user.name).to eq("Juan Pablo II")
      expect(user.description).to eq("new description")
      expect(user.email).to eq(email)
    end

    it "updating only career returns success" do
      career = FactoryBot.create(:career)
      put "/profile", params: { user: { career_id: career.id } }, headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({ "message" => I18n.t("success.users.updated") })
      user.reload
      expect(user.career.id).to eq(career.id)
      expect(user.career.name).to eq(career.name)
    end

    it "updating only name returns success" do
      put "/profile", params: { user: { name: "Juan Pablo II" } }, headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({ "message" => I18n.t("success.users.updated") })
      user.reload
      expect(user.name).to eq("Juan Pablo II")
    end

    it "updating only description returns success" do
      put "/profile", params: { user: { description: "new description" } },
      headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({ "message" => I18n.t("success.users.updated") })
      user.reload
      expect(user.description).to eq("new description")
    end

    it "returns an error if the career id is invalid" do
      put "/profile",
        params: { user: { career_id: 0 } },
        headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq({ "error" => I18n.t("error.careers.not_found") })
    end
  end
end
