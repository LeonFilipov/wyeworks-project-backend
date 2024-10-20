require 'rails_helper'


# POST tutor_availability/:id/intersteds
# add_interest
# parametros por url 


RSpec.describe "AvailabilityTutors", type: :request do

  let!(:university) { FactoryBot.create(:university) }
  let!(:subject) { FactoryBot.create(:subject, university: university) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:user_tutor) { FactoryBot.create(:user) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user_tutor, topic: topic) }
  let!(:token) { JsonWebTokenService.encode(user_id: user_tutor.id) }
  let(:valid_topic_params) { {name:"nombre 1", description:"descripcion 1", image_url:"url 1", subject_id: subject.id } }
  let(:invalid_topic_params) { { name: "" } }
  let(:valid_availability_params) { {availability: "availability 1", description: "description 1", link: "link 1"} }
  let(:invalid_availability_params) { { availability: "", link: "" } }
  
  
  # GET /tutor_availability/:id
  # show 
  # parametros por url
  describe "GET /tutor_availability/:id" do
    context "Availability exists" do   
      it "returns the availability with correct attributes" do
        get "/tutor_availability/#{availability_tutor.id}",
          headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).keys).to eq([ "id", "description", "link", "availability", "topic" ])
        expect(JSON.parse(response.body)["id"]).to eq(availability_tutor.id)
      end
    end
    
    context "Availability does not exist" do 
      it "returns an error message" do
        get "/tutor_availability/-1",
          headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ "message" => "Availability not found" })
      end
    end
    
    context "Params are incorrect" do
      it "returns an error message if param is not a number" do
        get "/tutor_availability/abc",
          headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ "message" => "Availability not found" })
      end
    end
  end
  
  
  # POST /tutor_availability
  # create 
  # params.require(:topic).permit(:name, :description, :image_url, :subject_id)
  # params.require(:availability_tutor).permit(:availability, :description, :link)
  
  describe "POST /tutor_availability" do
    context "when creating topic and availability successfully" do
      it "creates a new topic and availability" do
        post "/tutor_availability", 
          params: { topic: valid_topic_params, availability_tutor: valid_availability_params },
          headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:created)
        expect(AvailabilityTutor.last.user_id).to eq(user_tutor.id)
        expect(AvailabilityTutor.last.topic_id).to eq(Topic.last.id)
        expect(JSON.parse(response.body)["message"]).to eq("Topic and availability created successfully")
      end
    end
  
    context "when there are validation errors" do
      context "with invalid topic parameters" do
        it "does not create a topic and returns 422 with errors" do
          expect {
            post "/tutor_availability", 
            params: { topic: invalid_topic_params, availability_tutor: valid_availability_params },
            headers: { 'Authorization': "Bearer #{token}" }
          }.not_to change(Topic, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)["errors"]).to be_present
        end
      end

      context "with invalid availability tutor parameters" do
        it "creates a topic but does not create availability tutor and returns 422" do
          expect {
            post "/tutor_availability", 
            params: { topic: valid_topic_params, availability_tutor: invalid_availability_params },
            headers: { 'Authorization': "Bearer #{token}" }
          }.to change(Topic, :count).by(1).and not_change(AvailabilityTutor, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)["errors"]).to be_present
        end
      end
    end

    context "when rescuing from RecordInvalid error" do
      it "rescues from RecordInvalid when saving the topic" do
        allow_any_instance_of(Topic).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(Topic.new))

        post "/tutor_availability", 
          params: { topic: valid_topic_params, availability_tutor: valid_availability_params },
          headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end

    context "when saving availability tutor fails" do
      it "returns 422 if saving availability tutor fails" do
        allow_any_instance_of(AvailabilityTutor).to receive(:save).and_return(false)

        post "/tutor_availability", params: { topic: valid_topic_params, availability_tutor: valid_availability_params },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end

    context "when parameters are missing or incorrect" do
      it "returns 422 if topic parameters are missing" do
        post "/tutor_availability", params: { availability_tutor: valid_availability_params },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to be_present
      end

      it "returns 422 if availability tutor parameters are missing" do
        post "/tutor_availability", params: { topic: valid_topic_params },
        headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to be_present
      end 
    end
  end  
end
