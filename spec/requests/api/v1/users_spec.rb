require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /api/v1/users/:id" do
    context "with authentication" do
      it "returns the user data" do
        get "/api/v1/users/#{user.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["id"]).to eq(user.id)
      end
    end

    context "without authentication" do
      it "returns status 401" do
        get "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/v1/users/:id" do
    context "with authentication" do
      it "updates the user data" do
        patch "/api/v1/users/#{user.id}", params: { user: { name: "New Name" } }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq("New Name")
      end

      it "returns error if the data is invalid" do
        patch "/api/v1/users/#{user.id}", params: { user: { email: "" } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "without authentication" do
      it "returns status 401" do
        patch "/api/v1/users/#{user.id}", params: { user: { name: "Novo Nome" } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/users" do
    let(:admin) { create(:user, admin: true) }
    let(:admin_token) { JWT.encode({ user_id: admin.id }, Rails.application.credentials.secret_key_base) }
    let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

    before do
      create_list(:user, 3)
    end

    it "returns all users for admin" do
      get "/api/v1/users", headers: admin_headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(4)
    end

    it "returns forbidden for non-admin user" do
      get "/api/v1/users", headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end
end
