require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }
  let!(:topic) { FactoryBot.create(:topic) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }
  let!(:interested) { FactoryBot.create(:interested, user: user, availability_tutor: availability_tutor) }
  let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor, status: 'confirmed') }
  let!(:participant) { FactoryBot.create(:participant, user: user, meet: meet) }

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

  describe "GET /profile/teach" do
    it "returns the topics and meets proposed by the user as a tutor" do
      get "/profile/teach", headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      # Check structure for teach response
      expect(body.keys).to eq(["meets_confirmed", "meets_pending", "meets_finished", "topics"])
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
      expect(body.keys).to eq(["meets_confirmed", "meets_pending", "meets_finished", "topics"])
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
        non_permitted_attribute: "non-editable",
        email: "non-editable"
      }}, headers: { "Authorization" => token }
      
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq({ "message" => I18n.t("success.users.updated") })
    end
  end

  describe "GET /users/:id/teach" do
    it "returns the teach response for a specific user" do
      get "/users/#{user.id}/teach", headers: { "Authorization" => token }
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      # Check structure for teach response
      expect(body.keys).to eq(["meets_confirmed", "meets_pending", "meets_finished", "topics"])
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
      expect(body.keys).to eq(["meets_confirmed", "meets_pending", "meets_finished", "topics"])
      expect(body["meets_confirmed"].first["id"]).to eq(meet.id)
      expect(body["topics"].first["id"]).to eq(topic.id)
      expect(body["topics"].first["name"]).to eq(topic.name)
    end
  end
end
