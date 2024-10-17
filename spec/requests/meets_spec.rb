require 'rails_helper'

RSpec.describe "Meets", type: :request do
  univerisity = FactoryBot.create(:university)
  subject = FactoryBot.create(:subject, university: univerisity)
  topic = FactoryBot.create(:topic, subject: subject)
  user_tutor = FactoryBot.create(:user)
  availability_tutor = FactoryBot.create(:availability_tutor, user: user_tutor, topic: topic)
  token = JsonWebTokenService.encode(user_id: user_tutor.id)

  describe "GET /available_meets (get all meets for a availability)" do
    it "Return no meets" do
      get "/available_meets", 
        params: { id_availability_tutor: availability_tutor.id },
        headers: { "Authorization" => "Bearer #{token}" } 
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end

    it "Return meets without params" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
      get "/available_meets", 
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it "Return meets with params" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
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
  end


end
