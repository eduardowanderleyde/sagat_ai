require "rails_helper"

RSpec.describe "Api::V1::BankAccounts", type: :request do
  let(:user) { create(:user, :with_bank_account) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/bank_accounts/:id' do
    context 'with authentication' do
      it 'returns the user bank account' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(user.bank_account.id)
      end
    end

    context 'without authentication' do
      it 'returns status 401' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/bank_accounts/:id/balance' do
    context 'with authentication' do
      it 'returns the account balance' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/balance", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['balance'].to_f).to eq(user.bank_account.balance.to_f)
      end
    end

    context 'without authentication' do
      it 'returns status 401' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/balance"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/bank_accounts/:id/statement' do
    before do
      create_list(:transaction, 3, source_account: user.bank_account)
      create_list(:transaction, 2, destination_account: user.bank_account)
    end

    context 'with authentication' do
      it 'returns the account statement' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement", headers: headers
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["transactions"].length).to eq(5)
      end

      it 'filters by date' do
        start_date = 1.day.ago
        end_date = Time.current
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement",
            params: { start_date: start_date, end_date: end_date },
            headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'filters by minimum value' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement",
            params: { min_amount: 50.00 },
            headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'filters by type' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement",
            params: { type: 'transfer' },
            headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without authentication' do
      it 'returns status 401' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
