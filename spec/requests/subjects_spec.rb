require 'rails_helper'

RSpec.describe "Subjects", type: :request do
    let!(:university) { FactoryBot.create(:university) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:token) { JsonWebTokenService.encode(user_id: user.id) }

describe "GET /universities/:university_id/subjects" do
    context "When the university exists" do
        it "returns a success response" do
            get "/universities/#{university.id}/subjects",
            headers: { "Authorization" => "Bearer #{token}" }
            expect(response).to have_http_status(:ok)
        end
    end

    context "When the university does not exist" do
        it "returns a not found response" do
            get "/universities/-1/subjects",
            headers: { "Authorization" => "Bearer #{token}" }
            expect(response).to have_http_status(:not_found)
        end
    end
end


describe "GET /universities/:university_id/subjects/:id" do
    let!(:subject) { FactoryBot.create(:subject, university: university) }

    context "When the university and subject exists" do
        it "returns a success response" do
            get "/universities/#{university.id}/subjects/#{subject.id}",
            headers: { "Authorization" => "Bearer #{token}" }
            expect(response).to have_http_status(:ok)
        end

        it "assigns the requested subject" do
            get "/universities/#{university.id}/subjects/#{subject.id}",
            headers: { "Authorization" => "Bearer #{token}" }
            expect(JSON.parse(response.body)["id"]).to eq(subject.id)
        end
    end

    context "When the subject does not exist" do
        it "returns a not found response" do
            get "/universities/#{university.id}/subjects/-1",
            headers: { "Authorization" => "Bearer #{token}" }
            expect(response).to have_http_status(:not_found)
        end
    end

    context "When the university does not exist" do
        it "returns a not found response" do
            get "/universities/-1/subjects/#{subject.id}",
            headers: { "Authorization" => "Bearer #{token}" }
            expect(response).to have_http_status(:not_found)
        end
    end
end

describe "POST /universities/:university_id/subjects" do
    context "when the university exists" do
        context "with valid atributtes" do
            it "creates a new subject for the university" do
                expect {
                    post "/universities/#{university.id}/subjects",
                    params: { subject: { name: "New Subject" } },
                    headers: { "Authorization" => "Bearer #{token}" }
                }.to change(Subject, :count).by(1)
            end

            it "returns a success response" do
                post "/universities/#{university.id}/subjects",
                params: { subject: { name: "New Subject" } },
                headers: { "Authorization" => "Bearer #{token}" }
                expect(response).to have_http_status(:created)
            end

            it "renders a JSON response with the new subject" do
                post "/universities/#{university.id}/subjects",
                params: { subject: { name: "New Subject" } },
                headers: { "Authorization" => "Bearer #{token}" }
                expect(JSON.parse(response.body)["name"]).to eq("New Subject")
            end
        end

        context "with invalid attributes" do
            it "does not create a new subject" do
                expect {
                    post "/universities/#{university.id}/subjects",
                    params: { subject: { name: "" } },
                    headers: { "Authorization" => "Bearer #{token}" }
                }.to change(Subject, :count).by(0)
            end

            it "returns an unprocessable entity response" do
                post "/universities/#{university.id}/subjects",
                params: { subject: { name: "" } },
                headers: { "Authorization" => "Bearer #{token}" }
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it "renders a JSON error message" do
                post "/universities/#{university.id}/subjects",
                params: { subject: { name: "" } },
                headers: { "Authorization" => "Bearer #{token}" }
                expect(JSON.parse(response.body)["name"]).to eq([ "can't be blank" ])
            end
        end
    end

    context "when the university does not exist" do
        it "returns a not found response" do
            post "/universities/-1/subjects",
            params: { subject: { name: "New Subject" } },
            headers: { "Authorization" => "Bearer #{token}" }
            expect(response).to have_http_status(:not_found)
        end
    end
end
end
