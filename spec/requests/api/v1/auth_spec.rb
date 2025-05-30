require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/register" do
    let(:valid_params) do
      {
        user: {
          email: "test@example.com",
          password: "password123",
          name: "Test User",
          cpf: "52998224725"
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post '/api/v1/auth/register', params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'returns status 201' do
        post '/api/v1/auth/register', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'returns a JWT token' do
        post '/api/v1/auth/register', params: valid_params
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user with duplicate email' do
        create(:user, email: 'test@example.com')
        expect {
          post '/api/v1/auth/register', params: valid_params
        }.not_to change(User, :count)
      end

      it 'returns status 422' do
        post '/api/v1/auth/register', params: { user: { email: 'invalid' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /api/v1/auth/login' do
    let(:user) { create(:user, password: 'password123') }

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/api/v1/auth/login', params: { email: user.email, password: 'password123' }
        expect(JSON.parse(response.body)).to have_key('token')
      end

      it 'returns status 200' do
        post '/api/v1/auth/login', params: { email: user.email, password: 'password123' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      it 'returns status 401' do
        post '/api/v1/auth/login', params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
