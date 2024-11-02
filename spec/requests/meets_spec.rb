
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

      it "valid tutor_id" do
        get "/meets",
          params: { tutor_id: user_tutor.id },
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

      it "valid tutor_id and status" do
        get "/meets",
          params: { tutor_id: user_tutor.id, status: "cancelled" },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end

      it "valid tutor_id and topic_id" do
        get "/meets",
          params: { tutor_id: user_tutor.id, topic_id: topic.id },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
      end

      it "valid tutor_id, topic_id and status" do
        get "/meets",
          params: { tutor_id: user_tutor.id, topic_id: topic.id, status: "cancelled" },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
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

      it "invalid tutor_id" do
        get "/meets",
          params: { tutor_id: 0 },
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
  
    it "returns meet details" do
      get "/meets/#{meet.id}",
          headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["status"]).to eq(meet.status)
    end
  
    it "returns not found for non-existent meet" do
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

  describe "POST /meets/:id/interesteds (add interested to a meet)" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }
    it "tutor can't be interested in his own meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.tutor_interested"))
    end

    it "Meet already cancelled or completed" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "cancelled")
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.already_status", status: "cancelled"))
      meet.status = "completed"
      meet.save
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.already_status", status: "completed"))
    end

    it "Add interested to a meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.interested"))
      meet = Meet.find_by(id: meet.id)
      expect(meet.count_interesteds).to eq(1)
      expect(meet.participants.size).to eq(1)
      expect(meet.participants[0].user_id).to eq(user.id)
      expect(Interested.find_by(user_id: user.id, availability_tutor_id: availability_tutor.id)).not_to be_nil
    end

    it "Add interested to a meet two times" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:ok)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.already_interested"))
    end

    it "Add interested to a meet with two users" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:ok)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user2.id)}" }
      expect(response).to have_http_status(:ok)
      meet = Meet.find(meet.id)
      expect(meet.count_interesteds).to eq(2)
      expect(meet.participants.size).to eq(2)
    end
  end

  describe "DELETE /meets/:id/interesteds (remove interested from a meet)" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }
    it "Meet already cancelled or completed" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "cancelled")
      participant = FactoryBot.create(:participant, meet: meet, user: user)
      delete "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.already_status", status: "cancelled"))
      meet.status = "completed"
      meet.save
      delete "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.already_status", status: "completed"))
    end

    it "Remove interested from a meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
      delete "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.not_interested"))
      meet = Meet.find(meet.id)
      expect(meet.count_interesteds).to eq(0)
      expect(meet.participants.size).to eq(0)
      expect(Participant.find_by(user_id: user.id, meet_id: meet.id)).to be_nil
      expect(Interested.find_by(user_id: user.id, availability_tutor_id: availability_tutor.id)).to be_nil
    end

    it "Remove interested from a meet two times" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
      delete "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
      delete "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.participants.not_found"))
    end

    it "Remove interested from a meet with two users" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:ok)
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user2.id)}" }
      expect(response).to have_http_status(:ok)
      delete "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:ok)
      meet = Meet.find(meet.id)
      expect(meet.count_interesteds).to eq(1)
      expect(meet.participants.size).to eq(1)
    end

    it "Remove interest from two different meets" do
      meet1 = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      meet2 = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet1.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:ok)
      post "/meets/#{meet2.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:ok)
      delete "/meets/#{meet1.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user1.id)}" }
      expect(response).to have_http_status(:ok)
      expect(Interested.find_by(user_id: user1.id, availability_tutor_id: availability_tutor.id)).not_to be_nil
    end
  end
end
