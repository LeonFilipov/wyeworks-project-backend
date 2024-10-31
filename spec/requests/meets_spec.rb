
require 'rails_helper'

RSpec.describe "Meets", type: :request do
  let!(:university) { FactoryBot.create(:university) }
  let!(:subject) { FactoryBot.create(:subject, university: university) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:user_tutor) { FactoryBot.create(:user) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user_tutor, topic: topic) }
  let!(:token) { JsonWebTokenService.encode(user_id: user_tutor.id) }

  describe "GET /meets (get all meets for a topic)" do
    before do
      Participant.delete_all
      Meet.delete_all
    end

    it "Return no meets" do
      get "/meets",
        params: { id_availability_tutor: availability_tutor.id },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end

    it "Return meets without params and fields check" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      get "/meets",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(1)
      expect(parsed_response[0].keys).to eq([ "id", "date_time", "status", "description", "link", "count_interesteds" ])
    end

    context "Return meets with params" do
      let!(:meet1) { FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "confirmed") }
      let!(:meet2) { FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "cancelled") }
      let!(:topic1) { FactoryBot.create(:topic, subject: subject) }
      let!(:user1) { FactoryBot.create(:user) }
      let!(:availability_tutor1) { FactoryBot.create(:availability_tutor, user: user1, topic: topic1) }
      let!(:meet3) { FactoryBot.create(:meet, availability_tutor: availability_tutor1) }
      let!(:meet4) { FactoryBot.create(:meet, availability_tutor: availability_tutor1, status: "cancelled") }
      it "status cancelled" do
        get "/meets",
          params: { status: "cancelled" },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
      end

      it "valid topic_id" do
        get "/meets",
          params: { topic_id: topic.id },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
      end

      it "valid participant_id" do
        get "/meets",
          params: { participant_id: user_tutor.id },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end

      it "valid participant_id and status" do
        get "/meets",
          params: { participant_id: user_tutor.id, status: "cancelled" },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end

      it "valid participant_id and topic_id" do
        get "/meets",
          params: { participant_id: user_tutor.id, topic_id: topic1.id },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end

      it "valid participant_id, topic_id and status" do
        get "/meets",
          params: { participant_id: user_tutor.id, topic_id: topic1.id, status: "cancelled" },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end

      it "invalid topic_id" do
        get "/meets",
          params: { topic_id: 0 },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end

      it "invalid participant_id" do
        get "/meets",
          params: { participant_id: 0 },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end

      it "invalid status" do
        get "/meets",
          params: { status: "invalid" },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end

      it "no params" do
        get "/meets",
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(4)
      end
    end
  end

  describe "GET /meets/:id (show details for a specific meet)" do
    let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor) }

    it "Return meet" do
      get "/meets/#{meet.id}",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(meet.id)
    end

    it "Meet not found" do
      get "/meets/0",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.not_found"))
    end
  end

  describe "PATCH/PUT /meets/:id (confirm a meet)" do
    it "No authorization" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      non_authorized_user = FactoryBot.create(:user)
      unauthorized_token = JsonWebTokenService.encode(user_id: non_authorized_user.id)
      patch "/meets/#{meet.id}",
      params: { meet: { date: "2021-12-12 12:00:00", description: "Description" } },
      headers: { "Authorization" => "Bearer #{unauthorized_token}" }
      expect(response).to have_http_status(:unauthorized)
    end

    it "Confirm a meet two times" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      patch "/meets/#{meet.id}",
        params: { meet: { date: "2021-12-12 12:00:00", description: "Description" } },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.confirmed"))

      patch "/meets/#{meet.id}",
        params: { meet: { date: "2021-12-12 12:00:01", description: "Description 2" } },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.already_status", status: "confirmed"))
    end

    it "Meet don't exist" do
      patch "/meets/0",
        params: { meet: { date: "2021-12-12 12:00:00", description: "Description" } },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.not_found"))
    end
  end
end
