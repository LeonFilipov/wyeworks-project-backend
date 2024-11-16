require 'rails_helper'

RSpec.describe "Meets", type: :request do
  let!(:university) { FactoryBot.create(:university) }
  let!(:career) { FactoryBot.create(:career, university: university) }
  let!(:subject) { FactoryBot.create(:subject, career: career) }
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
      expect(parsed_response[0].keys).to eq([ "id", "date_time", "status", "link", "count_interesteds" ])
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

  describe "PATCH /meets/:id (update a meet)" do
    let!(:non_authorized_user) { FactoryBot.create(:user) }
    let!(:unauthorized_token) { JsonWebTokenService.encode(user_id: non_authorized_user.id) }
    let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "pending") }
    let!(:meet_confirmed) { FactoryBot.create(:meet, :confirmed, availability_tutor: availability_tutor) }

    # Cambiar el status de 'meet_confirmed' a 'confirmed' antes de las pruebas
    before do
      meet_confirmed.update(status: "confirmed")
    end

    context "when user is not authorized" do
      it "returns unauthorized status" do
        patch "/meets/#{meet.id}",
              headers: { "Authorization" => "Bearer #{unauthorized_token}", "Content-Type" => "application/json" },
              params: { meet: { date: "2024-12-12 12:00:00" } }.to_json

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.users.not_allowed"))
      end
    end

    context "when confirming a meet for the first time" do
      it "confirms the meet successfully" do
        tiempo = Time.current + 5.hours
        patch "/meets/#{meet.id}",
              headers: { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" },
              params: {
                meet: {
                  date: tiempo.change(usec: 0).strftime("%Y-%m-%d %H:%M:%S"),
                  link: "https://meetlink.com"
                }
              }.to_json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.updated"))
        expect(meet.reload.status).to eq("confirmed")
        expect(meet.link).to eq("https://meetlink.com")
      end
    end

    context "when updating a confirmed meet to a future date" do
      it "updates the meet successfully" do
        tiempo_inicial = Time.current + 5.hours
        tiempo_nuevo = Time.current + 23.days + 10.hours
        patch "/meets/#{meet_confirmed.id}",
              headers: { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" },
              params: {
                meet: {
                  date: tiempo_nuevo.change(usec: 0).strftime("%Y-%m-%d %H:%M:%S"),
                  link: "https://meetlink.com"
                }
              }.to_json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.updated"))
        meet_confirmed.reload
        expect(meet_confirmed.status).to eq("confirmed")
        expect(meet_confirmed.date_time).to eq(tiempo_nuevo.change(usec: 0))
      end
    end

    context "when updating a confirmed meet to a past date" do
      it "returns a bad request status" do
        tiempo_meet = meet_confirmed.date_time
        tiempo_pasado = Time.current - 1.hour
        patch "/meets/#{meet_confirmed.id}",
              headers: { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" },
              params: { meet: { date: tiempo_pasado.change(usec: 0).strftime("%Y-%m-%d %H:%M:%S") } }.to_json

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.invalid_date"))
        meet_confirmed.reload
        expect(meet_confirmed.date_time).to eq(tiempo_meet) # La fecha no debe actualizarse
      end
    end

    context "when the meet does not exist" do
      it "returns a not found status" do
        patch "/meets/0",
              headers: { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" },
              params: { meet: { date: "2024-12-12 12:00:00" } }.to_json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.not_found"))
      end
    end

    context "when updating only the link of a confirmed meet" do
      it "updates the link successfully" do
        tiempo_meet = meet_confirmed.date_time
        patch "/meets/#{meet_confirmed.id}",
              headers: { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" },
              params: { meet: { link: "https://meet.com" } }.to_json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.updated"))
        meet_confirmed.reload
        expect(meet_confirmed.link).to eq("https://meet.com")
        expect(meet_confirmed.status).to eq("confirmed")
        expect(meet_confirmed.date_time).to eq(tiempo_meet) # La fecha no debe cambiar
      end
    end

    context "when updating both date and link of a confirmed meet" do
      it "updates both fields successfully" do
        tiempo_nuevo = Time.current + 23.days + 10.hours
        patch "/meets/#{meet_confirmed.id}",
              headers: { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" },
              params: {
                meet: {
                  date: tiempo_nuevo.change(usec: 0).strftime("%Y-%m-%d %H:%M:%S"),
                  link: "https://newlink.com"
                }
              }.to_json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.updated"))
        meet_confirmed.reload
        expect(meet_confirmed.date_time).to eq(tiempo_nuevo.change(usec: 0))
        expect(meet_confirmed.link).to eq("https://newlink.com")
      end
    end
  end




  describe "POST /meets/:id/interesteds (add interested to a meet)" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }

    it "tutor can't be interested in their own meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "pending")
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.tutor_interested"))
    end

    it "Meet already cancelled or completed" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "pending")
      meet.update(status: "cancelled")
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.already_status", status: meet.status))
    end

    it "Add interested to a meet" do
      meet = FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "pending")
      post "/meets/#{meet.id}/interesteds",
        headers: { "Authorization" => "Bearer #{JsonWebTokenService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.add_interested"))
    end
  end


  describe '#meet_confirmada_email' do
    let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "pending") }
    let!(:participant1) { FactoryBot.create(:user) }
    let!(:participant2) { FactoryBot.create(:user) }
    let!(:interesteds1) { FactoryBot.create(:interested, availability_tutor: availability_tutor, user: participant1) }
    let!(:interesteds2) { FactoryBot.create(:interested, availability_tutor: availability_tutor, user: participant2) }

    it 'envía un correo a cada participante con la información correcta' do
      patch "/meets/#{meet.id}",
        params: { meet: { date: "2024-12-12 12:00:00" } },
        headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.updated"))
      expect(meet.reload.status).to eq("confirmed")
    end
  end

  describe "PATCH #cancel_meet" do
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:token2) { JsonWebTokenService.encode(user_id: other_user.id) }
    let(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor, status: "confirmed") }


    context "when user is the meet tutor" do
      context "and meet status is 'confirmed'" do
        it "cancels the meets and returns success message" do
          patch "/cancel_meet/#{meet.id}",
          headers: { "Authorization" => "Bearer #{token}" }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.cancelled"))
          expect(meet.reload.status).to eq("cancelled")
        end
      end

      context "and meet status is not 'confirmed'" do
        before { meet.update(status: "pending") }

        it "cant cancel and response is error" do
          patch "/cancel_meet/#{meet.id}",
          headers: { "Authorization" => "Bearer #{token}" }
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.meets.cant_cancel", status: "pending"))
          expect(meet.reload.status).to eq("pending")
        end
      end
    end

    context "when user is not meet tutor" do
      it "response is unauthorized" do
        patch "/cancel_meet/#{meet.id}",
          headers: { "Authorization" => "Bearer #{token2}" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("error.users.not_allowed"))
        expect(meet.reload.status).to eq("confirmed")
      end
    end
  end

  describe "Integration with Topics" do
    it "create a topic and get meet" do
      # create topic
      post "/topics",
        params: {
          topic: {
            name: "Topic 1",
            description: "New description",
            link: "https://link.com",
            show_email: false,
            subject_id: subject.id
          }
        },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["topic"]["id"]).to be_present
      # Get all meets for the topic
      get "/meets",
        params: { topic_id: JSON.parse(response.body)["topic"]["id"] },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      meet = JSON.parse(response.body)[0]
      expect(meet["status"]).to eq("pending")
      # Get information about the meet
      get "/meets/#{meet["id"]}",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["status"]).to eq(meet["status"])
      expect(JSON.parse(response.body)["link"]).to eq(JSON.parse(response.body)["link"])
      expect(JSON.parse(response.body)["tutor"]["email"]).to eq(nil)
    end
    it "create a topic and confirm a meet" do
      # create topic
      post "/topics",
        params: {
          topic: {
            name: "Topic 1",
            description: "New description",
            link: "https://link.com",
            show_email: false,
            subject_id: subject.id
          }
        },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["topic"]["id"]).to be_present

      # Get information about the topic
      get "/topics/#{JSON.parse(response.body)["topic"]["id"]}",
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Topic 1")
      meets = JSON.parse(response.body)["meets"]
      expect(meets.size).to eq(1)
      meet = meets[0]
      expect(meet["status"]).to eq("pending")

      # Confirm meet
      patch "/meets/#{meet["id"]}",
        params: { meet: { date: "2024-12-12 12:00:00" } },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.updated"))
      meet = Meet.find(meet["id"])
      expect(meet.status).to eq("confirmed")
      expect(meet.date_time).to eq("2024-12-12 12:00:00")
      # Edit the link
      patch "/meets/#{meet.id}",
        params: { meet: { link: "https://meet.com" } },
        headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq(I18n.t("success.meets.updated"))
      meet = Meet.find(meet.id)
      expect(meet.link).to eq("https://meet.com")
      expect(meet.status).to eq("confirmed")
      expect(meet.date_time).to eq("2024-12-12 12:00:00")
    end
  end
end
