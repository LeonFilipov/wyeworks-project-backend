require 'rails_helper'

RSpec.describe "Meets", type: :request do
  let!(:university) { FactoryBot.create(:university) }
  let!(:subject) { FactoryBot.create(:subject, university: university) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:user_tutor) { FactoryBot.create(:user) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user_tutor, topic: topic) }
  let!(:token) { JsonWebTokenService.encode(user_id: user_tutor.id) }

  describe "GET /available_meets (get all meets for a availability)" do
    it "Return no meets" do
      get "/available_meets",
        params: { id_availability_tutor: availability_tutor.id },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end

    context "Only one meet created endpoint" do
      let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor) }

      it "Return meets without params and fields check" do
        get "/available_meets",
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(1)
        expect(parsed_response[0].keys).to eq([ "id", "topic_name", "meeting_date", "meet_status", "tutor", "subject", "interested", "count_interesteds" ])
        tutor = parsed_response[0]["tutor"]
        expect(tutor["id"]).to eq(user_tutor.id)
        expect(tutor["name"]).to eq(user_tutor.name)
      end

      it "Return meets with params" do
        get "/available_meets",
          params: { id_availability_tutor: availability_tutor.id },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)

        get "/available_meets",
          params: { topic_id: topic.id },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)

        get "/available_meets",
          params: { subject_id: subject.id },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)

        get "/available_meets",
          params: { interested: false },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)

        get "/available_meets",
          params: { meet_state: "pending" },
          headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end
  end

  describe "POST /meet/:id (confirm a meet)" do
    it "No authorization" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      non_authorized_user = FactoryBot.create(:user)
      unauthorized_token = JsonWebTokenService.encode(user_id: non_authorized_user.id)
      post "/meet/#{meet.id}",
      params: { meet: { date: "2021-12-12 12:00:00", description: "Description" } },
      headers: { "Authorization" => "Bearer #{unauthorized_token}" }
      expect(response).to have_http_status(:unauthorized)
    end

    it "Confirm a meet two times" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meet/#{meet.id}",
        params: { meet: { date: "2021-12-12 12:00:00", description: "Description" } },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Meet confirmed successfully")

      post "/meet/#{meet.id}",
        params: { meet: { date: "2021-12-12 12:00:01", description: "Description 2" } },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq("Meet already confirmed")
    end

    it "Meet dont exist" do
      post "/meet/0",
        params: { meet: { date: "2021-12-12 12:00:00", description: "Description" } },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Meet not found")
    end
  end

  describe "GET /profile/meets and /profile/meets/:id (get all meets for a user)" do
    it "Return no meets" do
      get "/profile/meets",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end

    it "Return meets" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      get "/profile/meets",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it "Return a specific meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      get "/profile/meets/#{meet.id}",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(meet.id)
    end
  end

  describe "PATCH /profile/meets/:id (cancel a meet)" do
    it "Successfully cancels a meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "pending")
      patch "/profile/meets/#{meet.id}",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Meet cancelled successfully")
      meet.reload
      expect(meet.status).to eq("cancelled")
    end

    it "Fails to cancel meet that does not belong to the user" do
      other_user = FactoryBot.create(:user)
      other_tutor = FactoryBot.create(:availability_tutor, user: other_user)
      meet = FactoryBot.create(:meet, availability_tutor: other_tutor, status: "pending")
      patch "/profile/meets/#{meet.id}",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Meet not found or you are not the tutor")
    end

    it "Fails to cancel an already cancelled meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "cancelled")
      patch "/profile/meets/#{meet.id}",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("Meet is already cancelled, cannot cancel")
    end

    it "Meet not found" do
      patch "/profile/meets/0",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Meet not found or you are not the tutor")
    end
  end


  describe "POST/DELETE /meets/:id/interest (manage interest in a meet)" do
    it "Successfully interested in a meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interest",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Interest expressed successfully")
      meet = Meet.find(meet.id)
      expect(meet.users.size).to eq(1)
      expect(meet.count_interesteds).to eq(1)
    end

    it "Already interested in a meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interest",
        headers: { "Authorization" => "Bearer #{token}" }
      post "/meets/#{meet.id}/interest",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq("User already interested in this meet")
    end

    it "Successfully uninterested in a meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      post "/meets/#{meet.id}/interest",
        headers: { "Authorization" => "Bearer #{token}" }
      delete "/meets/#{meet.id}/interest",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Interest removed successfully")
      meet = Meet.find(meet.id)
      expect(meet.users.size).to eq(0)
      expect(meet.count_interesteds).to eq(0)
    end

    it "Meet not found" do
      post "/meets/0/interest",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Meet not found")
    end
  end
end
