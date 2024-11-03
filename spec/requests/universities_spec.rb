require 'rails_helper'

RSpec.describe "UniversitiesController", type: :request do
  let!(:user_tutor) { FactoryBot.create(:user) }
  let!(:token) { JsonWebTokenService.encode(user_id: user_tutor.id) }
  let!(:university) { FactoryBot.create(:university) }
let!(:career) { FactoryBot.create(:career, university: university) }


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
end
