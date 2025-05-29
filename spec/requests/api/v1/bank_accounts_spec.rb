require 'rails_helper'

RSpec.describe 'Api::V1::BankAccounts', type: :request do
  let(:user) { create(:user, :with_bank_account) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/bank_accounts/:id' do
    context 'com autenticação' do
      it 'retorna a conta bancária do usuário' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(user.bank_account.id)
      end
    end

    context 'sem autenticação' do
      it 'retorna status 401' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/bank_accounts/:id/balance' do
    context 'com autenticação' do
      it 'retorna o saldo da conta' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/balance", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['balance'].to_f).to eq(user.bank_account.balance.to_f)
      end
    end

    context 'sem autenticação' do
      it 'retorna status 401' do
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

    context 'com autenticação' do
      it 'retorna o extrato da conta' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq(5)
      end

      it 'filtra por data' do
        start_date = 1.day.ago
        end_date = Time.current
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement",
            params: { start_date: start_date, end_date: end_date },
            headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'filtra por valor mínimo' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement",
            params: { min_amount: 50.00 },
            headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'filtra por tipo' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement",
            params: { type: 'transfer' },
            headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'sem autenticação' do
      it 'retorna status 401' do
        get "/api/v1/bank_accounts/#{user.bank_account.id}/statement"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
