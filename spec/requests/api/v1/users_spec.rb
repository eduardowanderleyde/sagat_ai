require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "GET /api/v1/users/:id" do
    context "com autenticação" do
      it "retorna os dados do usuário" do
        get "/api/v1/users/#{user.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["id"]).to eq(user.id)
      end
    end

    context "sem autenticação" do
      it "retorna status 401" do
        get "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/v1/users/:id" do
    context "com autenticação" do
      it "atualiza os dados do usuário" do
        patch "/api/v1/users/#{user.id}", params: { user: { name: "Novo Nome" } }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq("Novo Nome")
      end

      it "retorna erro se os dados forem inválidos" do
        patch "/api/v1/users/#{user.id}", params: { user: { email: "" } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "sem autenticação" do
      it "retorna status 401" do
        patch "/api/v1/users/#{user.id}", params: { user: { name: "Novo Nome" } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
