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

    context 'com parâmetros válidos' do
      it 'cria um novo usuário' do
        expect {
          post '/api/v1/auth/register', params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'retorna status 201' do
        post '/api/v1/auth/register', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'retorna um token JWT' do
        post '/api/v1/auth/register', params: valid_params
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'com parâmetros inválidos' do
      it 'não cria um usuário com email duplicado' do
        create(:user, email: 'test@example.com')
        expect {
          post '/api/v1/auth/register', params: valid_params
        }.not_to change(User, :count)
      end

      it 'retorna status 422' do
        post '/api/v1/auth/register', params: { user: { email: 'invalid' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /api/v1/auth/login' do
    let(:user) { create(:user, password: 'password123') }

    context 'com credenciais válidas' do
      it 'retorna um token JWT' do
        post '/api/v1/auth/login', params: { email: user.email, password: 'password123' }
        expect(JSON.parse(response.body)).to have_key('token')
      end

      it 'retorna status 200' do
        post '/api/v1/auth/login', params: { email: user.email, password: 'password123' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'com credenciais inválidas' do
      it 'retorna status 401' do
        post '/api/v1/auth/login', params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
