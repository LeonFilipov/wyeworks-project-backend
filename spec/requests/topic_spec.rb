require 'rails_helper'

RSpec.describe "Topics", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:university) { FactoryBot.create(:university) }
  let!(:subject) { FactoryBot.create(:subject, university: university) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }
  
  describe "GET /topics" do
    let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }
    context "Without params" do
      it "returns http success" do
        get "/topics",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
      end
    end

    context "With user_id" do
      let!(:user1) { FactoryBot.create(:user) }
      let!(:availability_tutor1) { FactoryBot.create(:availability_tutor, user: user1, topic: topic) }

      it "returns http success with topics given by the tutor" do
        get "/topics", params: {
          'user_id': user.id
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(response.body).to include(user.id)
        expect(response.body).to_not include(user1.id)
      end
    end

    context "With subject_id" do
      let!(:user1) { FactoryBot.create(:user) }
      let!(:subject1) { FactoryBot.create(:subject, university: university) }
      let!(:topic1) { FactoryBot.create(:topic, subject: subject1) }
      let!(:availability_tutor1) { FactoryBot.create(:availability_tutor, user: user1, topic: topic1) }

      it "returns http success with topics belonging to any subject" do
        get "/topics", params: {
          'subject_id': subject.id
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(response.body).to include(subject.id.to_s)
        expect(response.body).to_not include(subject1.id.to_s)
      end
    end
  end

  describe "GET /topics/:id" do
    let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }
    it "returns http not found" do
      get "/topics/1",
      headers: { 'Authorization': "Bearer #{token}" }
      expect(response.body).to include("Topic not found")
    end

    it "returns http success without interesteds" do
      get "/topics/#{availability_tutor.id}",
      headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      parsed = JSON.parse(response.body)
      expect(parsed["availability_id"]).to eq(availability_tutor.id)
      expect(parsed["interested_users"]).to eq([])
    end

    it "returns http success with interesteds" do
      user_interested = FactoryBot.create(:user)
      FactoryBot.create(:interested, user: user_interested, availability_tutor: availability_tutor)
      get "/topics/#{availability_tutor.id}",
      headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      parsed = JSON.parse(response.body)
      expect(parsed["availability_id"]).to eq(availability_tutor.id)
      expect(parsed["interesteds"]).to eq(1)
      expect(parsed["interested_users"].first["id"]).to eq(user_interested.id)
    end
  end

  describe "GET /proposed_topics" do
    context "Without proposed topics" do
      it "returns http success" do
        get "/proposed_topics",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(response.body).to eq("[]")
      end
    end

    context "With proposed topics" do
      it "returns http success" do
        get "/proposed_topics",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(response).to_not be_nil
      end
    end
  end

  describe "DELETE /proposed_topics/:availability_id" do
    let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }

    context "Without meets created" do
      it "returns http success without interesteds" do
        delete "/proposed_topics/#{availability_tutor.id}",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(Topic.find_by(id: topic.id)).to be_nil
        expect(AvailabilityTutor.find_by(id: availability_tutor.id)).to be_nil
      end

      it "returns http success with interesteds" do
        user_interested = FactoryBot.create(:user)
        FactoryBot.create(:interested, user: user_interested,  availability_tutor: availability_tutor)
        delete "/proposed_topics/#{availability_tutor.id}",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(Interested.find_by(user_id: user_interested.id)).to be_nil
      end
    end

    context "With meets created" do
      let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor) }

      it "returns http success without intrested in meet" do
        delete "/proposed_topics/#{availability_tutor.id}",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(Meet.find_by(id: meet.id)).to be_nil
      end

      it "returns http success with intrested in meet" do
        user_interested = FactoryBot.create(:user)
        FactoryBot.create(:interested, user: user_interested, availability_tutor: availability_tutor)
        FactoryBot.create(:participant, user: user_interested, meet: meet)
        delete "/proposed_topics/#{availability_tutor.id}",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(Meet.find_by(id: meet.id)).to be_nil
        expect(Participant.find_by(user_id: user_interested.id)).to be_nil
      end
    end
  end
end
