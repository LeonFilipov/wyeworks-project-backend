require 'rails_helper'

RSpec.describe "UsersControllers", type: :request do
  let!(:user) { FactoryBot.create(:user, career: nil) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }
  let!(:topic) { FactoryBot.create(:topic) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }
  let!(:interested) { FactoryBot.create(:interested, user: user, availability_tutor: availability_tutor) }
  let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor, status: 'confirmed') }
  let!(:participant) { FactoryBot.create(:participant, user: user, meet: meet) }

  describe "GET /profile" do
    it "returns the current user with correct attributes" do
      get "/profile", headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).first.keys).to eq([ "id", "name", "email", "description", "image_url", "career" ])
      expect(JSON.parse(response.body).first["name"]).to eq(user.name)
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
      expect(JSON.parse(response.body).first["career"]).to be_nil
    end
  end

  describe "GET /profile/teach" do
    it "returns the topics and meets proposed by the user as a tutor" do
      get "/profile/teach", headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      # Check structure for teach response
      expect(body.keys).to eq([ "meets_confirmed", "meets_pending", "meets_finished", "topics" ])
      expect(body["meets_confirmed"].first["id"]).to eq(meet.id)
      expect(body["topics"].first["id"]).to eq(topic.id)
      expect(body["topics"].first["name"]).to eq(topic.name)
    end
  end

  describe "GET /profile/learn" do
    it "returns the topics and meets the user is interested in as a student" do
      get "/profile/learn", headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      # Check structure for learn response
      expect(body.keys).to eq([ "meets_confirmed", "meets_pending", "meets_finished", "topics" ])
      expect(body["meets_confirmed"].first["id"]).to eq(meet.id)
      expect(body["topics"].first["id"]).to eq(topic.id)
      expect(body["topics"].first["name"]).to eq(topic.name)
    end
  end

  describe "PUT /profile" do
    it "updates the current user with the correct attributes and ignores non-permitted attributes" do
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

  describe "GET /users/:id/teach" do
    it "returns the teach response for a specific user" do
      get "/users/#{user.id}/teach", headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      # Check structure for teach response
      expect(body.keys).to eq([ "meets_confirmed", "meets_pending", "meets_finished", "topics" ])
      expect(body["meets_confirmed"].first["id"]).to eq(meet.id)
      expect(body["topics"].first["id"]).to eq(topic.id)
      expect(body["topics"].first["name"]).to eq(topic.name)
    end
  end

  describe "GET /users/:id/learn" do
    it "returns the learn response for a specific user" do
      get "/users/#{user.id}/learn", headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      # Check structure for learn response
      expect(body.keys).to eq([ "meets_confirmed", "meets_pending", "meets_finished", "topics" ])
      expect(body["meets_confirmed"].first["id"]).to eq(meet.id)
      expect(body["topics"].first["id"]).to eq(topic.id)
      expect(body["topics"].first["name"]).to eq(topic.name)
    end
  end
end
