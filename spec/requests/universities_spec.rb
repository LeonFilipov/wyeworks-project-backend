require 'rails_helper'

RSpec.describe "UniversitiesController", type: :request do
    let!(:user_tutor) { FactoryBot.create(:user) }
    let!(:token) { JsonWebTokenService.encode(user_id: user_tutor.id) }
    let!(:university) { FactoryBot.create(:university) }

  # GET #index
  describe "GET #index" do
    it "returns a success response" do
      get universities_path, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
    end
  end

  # GET #show when the university exists
  describe "GET #show" do
    context "when the university exists" do
      it "returns the university" do
        get university_path(university.id), headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:success)
      end
    end

    context "when the university does not exist" do
      it "returns a not found response" do
        get university_path(-1), headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # POST #create with valid parameters
  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new university" do
        expect {
          post universities_path, params: { university: { name: "New University", location: "New Location" } }, headers: { "Authorization" => "Bearer #{token}" }
        }.to change(University, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable entity response" do
        post universities_path, params: { university: { name: "", location: "" } }, headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # PATCH #update with valid parameters
  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the university" do
        patch university_path(university.id), params: { university: { name: "Updated Name" } }, headers: { "Authorization" => "Bearer #{token}" }
        university.reload
        expect(university.name).to eq("Updated Name")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable entity response" do
        patch university_path(university.id), params: { university: { name: "" } }, headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # DELETE #destroy
  describe "DELETE #destroy" do
    context "when the university exists" do
      it "deletes the university" do
        university_to_delete = create(:university)
        expect {
          delete university_path(university_to_delete.id), headers: { "Authorization" => "Bearer #{token}" }
        }.to change(University, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the university does not exist" do
      it "returns a not found response" do
        delete university_path(-1), headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
