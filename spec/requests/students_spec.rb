require 'rails_helper'

RSpec.describe "StudentsController", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:university) { FactoryBot.create(:university) }
  let!(:subject) { FactoryBot.create(:subject, university: university) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }

  describe "POST #request_topic" do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:token1) { JsonWebTokenService.encode(user_id: user1.id) }
    context "when topic exists" do
      it "adds the student to the topic" do
        post "/students/topics/#{ topic.id }/request_topic",
        headers: { 'Authorization': "Bearer #{token1}" }
        expect(topic.users).to include(user1)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("Student successfully added to topic")
      end
    end

    context "when topic does not exist" do
      it "returns an error" do
        post "/students/topics/-1/request_topic",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Couldn't find Topic")
      end
    end
  end


end
