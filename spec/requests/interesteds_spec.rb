require 'rails_helper'

RSpec.describe "InterestedsController", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor) }
  let!(:interested) { FactoryBot.create(:interested, user: user, availability_tutor: availability_tutor) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }

  # GET #index
  describe "GET #index" do
    it "returns a list of users interested in a tutor availability" do
      get "/tutor_availability/#{availability_tutor.id}/interesteds", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.first['user_id']).to eq(user.id)
    end
  end

end
