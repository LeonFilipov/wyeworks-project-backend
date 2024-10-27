RSpec.describe "SessionsController", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:token) { JsonWebTokenService.encode(user_id: user.id) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_request).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET #oauth2_callback' do
    let(:user_info) { { "email" => "test@example.com" } }
    let(:access_token) { "fake_access_token" }
    let(:user) { instance_double(User, id: 1, save: true) }

    before do
      allow(GoogleAuthService).to receive(:get_access_token).and_return("access_token" => access_token)
      allow(GoogleAuthService).to receive(:get_user_info).and_return(user_info)
      allow(User).to receive(:google_auth).and_return(user)
      allow(JsonWebTokenService).to receive(:encode).and_return("fake_jwt_token")
      allow(UserMailer).to receive_message_chain(:welcome_email_no_AR, :deliver_now)
    end

    context 'when user is saved successfully' do
      it 'returns a JWT token' do
        get '/auth/google_oauth2/callback', params: { code: 'fake_code' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["token"]).to eq("fake_jwt_token")
      end

      it 'sends a welcome email if it is the first time' do
        allow(User).to receive(:find_by).and_return(nil)
        get '/auth/google_oauth2/callback', params: { code: 'fake_code' }
        expect(UserMailer).to have_received(:welcome_email_no_AR).with(user)
      end
    end

    context 'when user is not saved successfully' do
      before do
        allow(user).to receive(:save).and_return(false)
      end

      it 'returns an error message' do
        get '/auth/google_oauth2/callback', params: { code: 'fake_code' }
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)["error"]).to eq("Error creating user")
      end
    end
  end
end
