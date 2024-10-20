require 'rails_helper'

RSpec.describe "UniversitiesController", type: :request do
  let!(:user_tutor) { FactoryBot.create(:user) }
  let!(:token) { JsonWebTokenService.encode(user_id: user_tutor.id) }
  let!(:university) { FactoryBot.create(:university) }


  # GET #index
  describe "GET #index" do
    it "returns a success response" do
      get "/universities", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
    end
  end

  # GET #show when the university exists
  describe "GET #show" do
    context "when the university exists" do
      it "returns the university" do
        get "/universities/#{university.id}", headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:success)
      end
    end

    context "when the university does not exist" do
      it "returns a not found response" do
        get "/universities/-1", headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # POST #create with valid parameters
  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new university" do
        expect {
          post "/universities", params: { university: { name: "New University", location: "New Location" } }, headers: { "Authorization" => "Bearer #{token}" }
        }.to change(University, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable entity response" do
        post "/universities", params: { university: { name: "", location: "" } }, headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
