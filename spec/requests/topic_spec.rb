require 'rails_helper'

RSpec.describe "Topics", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:university) { FactoryBot.create(:university) }
  let!(:subject) { FactoryBot.create(:subject, university: university) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }

  describe "GET /topics" do
    context "Without params" do
      it "returns http success" do
        get "/topics",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(1)
      end

      it "returns empty array" do
        Topic.destroy_all
        get "/topics",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "With user_id" do
      it "returns http success with topics given by the tutor" do
        get "/topics", params: {
          'user_id': user.id
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(1)
        topic = Topic.find(parsed_response.first["id"])
        expect(topic.tutor.id).to eq(user.id)
      end
    end

    context "With subject_id" do
      it "returns http success with topics belonging to any subject" do
        get "/topics", params: {
          'subject_id': subject.id
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(1)
        topic = Topic.find(parsed_response.first["id"])
        expect(topic.subject.id).to eq(subject.id)
      end

      it "returns empty array" do
        get "/topics", params: {
          'subject_id': 1
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "With subject_id and user_id" do
      let!(:user2) { FactoryBot.create(:user) }
      let!(:subject2) { FactoryBot.create(:subject, university: university) }
      let!(:topic2) { FactoryBot.create(:topic, subject: subject2) }
      let!(:availability_tutor2) { FactoryBot.create(:availability_tutor, user: user2, topic: topic2) }
      it "returns http success" do
        get "/topics", params: {
          'subject_id': subject2.id,
          'user_id': user2.id
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(1)
        topic = Topic.find(parsed_response.first["id"])
        expect(topic.subject.id).to eq(subject2.id)
        expect(topic.tutor.id).to eq(user2.id)
      end

      it "returns empty array" do
        get "/topics", params: {
          'subject_id': subject2.id,
          'user_id': user.id
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe "GET /topics/:id" do
    # to do
  end

  describe "POST /topics" do
    context "With valid params" do
      it "returns http created" do
        post "/topics", params: {
          topic: {
            name: "New topic",
            description: "New description",
            link: "New link",
            show_email: true,
            subject_id: subject.id
          }
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:created)
        parsed = JSON.parse(response.body)
        expect(parsed["message"]).to eq(I18n.t("success.topics.created"))
        newTopic = Topic.find_by(name: "New topic")
        expect(newTopic).not_to be_nil
        expect(newTopic.description).to eq("New description")
        expect(newTopic.link).to eq("New link")
        expect(newTopic.show_email).to eq(true)
        expect(newTopic.subject.id).to eq(subject.id)
      end
    end

    context "With invalid params" do
      it "subject_id not found" do
        post "/topics", params: {
          topic: {
            name: "New topic",
            description: "New description",
            link: "New link",
            show_email: true,
            subject_id: 0
          }
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        parsed = JSON.parse(response.body)
        expect(parsed["error"]).to eq("Validation failed: Subject must exist")
      end

      it "no subject_id provided" do
        post "/topics", params: {
          topic: {
            name: "New topic",
            description: "New description",
            link: "New link",
            show_email: true,
            subject_id: nil
          }
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Validation failed: Subject must exist, Subject can't be blank")
      end

      it "no name provided" do
        post "/topics", params: {
          topic: {
            name: nil,
            description: "New description",
            link: "New link",
            show_email: true,
            subject_id: subject.id
          }
        },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Validation failed: Name can't be blank")
      end
    end

    it "invalid show_email" do
      post "/topics", params: {
        topic: {
          name: "raaaaaa",
          description: "New description",
          link: "New link",
          show_email: "invalid",
          subject_id: subject.id
        }
      },
      headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.topics.created"))
      expect(Topic.find_by(name: "raaaaaa").show_email).to eq(true)
    end

    it "show_email nil" do
      post "/topics", params: {
        topic: {
          name: "raaaaaa",
          description: "New description",
          link: "New link",
          show_email: nil,
          subject_id: subject.id
        }
      },
      headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("Validation failed: Show email is not included in the list")
    end
  end
end
