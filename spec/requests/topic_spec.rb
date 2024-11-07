require 'rails_helper'

RSpec.describe "Topics", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:university) { FactoryBot.create(:university) }
  let!(:career) { FactoryBot.create(:career, university: university) }
  let!(:subject) { FactoryBot.create(:subject, career: career) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }

  describe "GET /topics" do
    context "Without params" do
      before do
        AvailabilityTutor.destroy_all
      end

      it "returns http success" do
        get "/topics",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
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
      let!(:subject2) { FactoryBot.create(:subject, career: career) }
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
    let!(:user2) { FactoryBot.create(:user) }
    let!(:subject2) { FactoryBot.create(:subject, career: career) }
    let!(:topic2) { FactoryBot.create(:topic, subject: subject2) }
    let!(:availability_tutor2) { FactoryBot.create(:availability_tutor, user: user2, topic: topic2) }
    context "when the topic exists" do
      it "returns http success and I proposed the topic" do
        get "/topics/#{topic.id}",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        parsed = JSON.parse(response.body)
        expect(parsed["name"]).to eq(topic.name)
        expect(parsed["proposed"]).to eq(true)
        expect(parsed.keys).to eq([ "name", "description", "link", "show_email", "subject_id", "proposed", "meets" ])
      end

      it "returns http success and I did not proposed the topic" do
        get "/topics/#{topic2.id}",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["name"]).to eq(topic2.name)
        expect(JSON.parse(response.body)["proposed"]).to eq(false)
      end
    end

    context "when the topic does not exist" do
      it "returns http not found" do
        get "/topics/-1",
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
      end
    end
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
        newTopic = Topic.find_by(id: parsed["topic"]["id"])
        expect(newTopic).not_to be_nil
        expect(newTopic.description).to eq("New description")
        expect(newTopic.link).to eq("New link")
        expect(newTopic.show_email).to eq(true)
        expect(newTopic.subject.id).to eq(subject.id)
        meet = Meet.find_by(availability_tutor_id: newTopic.availability_tutor.id)
        expect(meet.status).to eq("pending")
        expect(meet.date_time).to be_nil
        expect(meet.link).to eq(newTopic.link)
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

  describe "PATCH /topics/:id" do
    context "when the topic does not exist" do
      it "returns a not found error" do
        patch "/topics/-1", params: { topic: { name: "Updated Topic", description: topic.description, link: topic.link, show_email: topic.show_email } },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.topics.not_found"))
      end
    end

    context "when the topic exists but does not have an owner" do
      before do
        allow(TopicsService).to receive(:get_topic_owner).with(topic.id.to_s).and_return(nil)
      end

      it "returns a not found error" do
        patch "/topics/#{topic.id}", params: { topic: { name: "Updated Topic", description: topic.description, link: topic.link, show_email: topic.show_email }  },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.topics.not_found"))
      end
    end

    context "when the current user is not the owner of the topic" do
      let!(:user2) { FactoryBot.create(:user) }
      let!(:token2) { JsonWebTokenService.encode(user_id: user2.id) }

      it "returns an unauthorized error" do
        patch "/topics/#{topic.id}", params: { topic: { name: "Updated Topic", description: topic.description, link: topic.link, show_email: topic.show_email }  },
        headers: { 'Authorization': "Bearer #{token2}" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.users.not_allowed"))
      end
    end

    context "when the current user is the owner of the topic" do
      it "updates the topic and returns a success message" do
        patch "/topics/#{topic.id}", params: { topic: { name: "Updated Topic", description: "Updated description", link: topic.link, show_email: topic.show_email }  },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.topics.updated"))
        expect(topic.reload.name).to eq("Updated Topic")
        expect(topic.reload.description).to eq("Updated description")
      end
    end
  end

  describe "Integration tests" do
    it "Create a topic and get it" do
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
      topic_id = JSON.parse(response.body)["topic"]["id"]
      # created
      get "/topics/#{topic_id}",
        headers: { 'Authorization': "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      parsed = JSON.parse(response.body)
      expect(parsed["name"]).to eq("New topic")
      expect(parsed["proposed"]).to eq(true)
      expect(parsed.keys).to eq([ "name", "description", "link", "show_email", "subject_id", "proposed", "meets" ])
      meet = Meet.find_by(id: parsed["meets"].first["id"])
      expect(parsed["meets"].first["id"]).to eq(meet.id)
      expect(parsed["meets"].first["status"]).to eq(meet.status)
      expect(parsed["meets"].first["date_time"]).to eq(meet.date_time)
    end
  end
end
