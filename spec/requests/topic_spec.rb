require 'rails_helper'

RSpec.describe "Topics", type: :request do
  describe "DELETE /proposed_topics/:availability_id" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:university) { FactoryBot.create(:university) }
    let!(:subject) { FactoryBot.create(:subject, university: university) }
    let!(:topic) { FactoryBot.create(:topic, subject: subject) }
    let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }
    let!(:token) { JsonWebTokenService.encode(user_id: user.id) }

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
