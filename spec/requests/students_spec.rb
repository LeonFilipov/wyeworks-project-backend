require 'rails_helper'

RSpec.describe "StudentsController", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:university) { FactoryBot.create(:university) }
  let!(:subject) { FactoryBot.create(:subject, university: university) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }

  describe "POST #request_topic" do
    context "when topic exists" do
      it "adds the student to the topic" do
        post "/students/topics/#{ topic.id }/request_topic",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(topic.student_topics.find_by(user_id: user.id)).to be_present
        expect(JSON.parse(response.body)['message']).to eq("Student successfully added to topic")
      end
    end

    context "when topic does not exist" do
      it "returns an error without topic parameters" do
        post "/students/topics/10/request_topic",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:bad_request)
      end

      it "returns success with topic parameters" do
        post "/students/topics/1000/request_topic",
        params: { topic: { name: "New Topic", description: "New Description", subject_id: subject.id } },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(Topic.last.student_topics.find_by(user_id: user.id)).to be_present
        expect(JSON.parse(response.body)['message']).to eq("Student successfully added to topic")
      end
    end
  end

  describe "GET #my_requested_topics" do
    context "when topics are found" do
      it "returns the requested topics" do
        get "/students/my_requested_topics",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #requested_topics" do
    context "when topics exist" do
      it "returns the requested topics" do
        get "/students/requested_topics",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #interested_meetings" do
    let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }
    let!(:user1) { FactoryBot.create(:user) }
    let!(:token1) { JsonWebTokenService.encode(user_id: user1.id) }

    context "when meetings are found" do
      let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor) }
      let!(:participant) { FactoryBot.create(:participant, meet: meet, user: user1) }
      it "returns the interested meetings" do
        get "/interested_meetings",
        headers: { 'Authorization': "Bearer #{token1}" }
        expect(response).to have_http_status(:success)
      end
    end

    context "when no meetings are found" do
      it "returns a not found status" do
        get "/interested_meetings",
        headers: { 'Authorization': "Bearer #{token1}" }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
