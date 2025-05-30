require "rails_helper"

RSpec.describe "Api::V1::Transactions", type: :request do
  let(:user) { create(:user, :with_bank_account) }
  let(:destination_user) { create(:user, :with_bank_account) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'POST /api/v1/transactions' do
    let(:valid_params) do
      {
        transaction: {
          amount: 100.00,
          destination_account_id: destination_user.bank_account.id
        }
      }
    end

    context 'with authentication' do
      context 'with valid parameters' do
        it 'creates a new transaction' do
          expect {
            post '/api/v1/transactions', params: valid_params, headers: headers
          }.to change(Transaction, :count).by(1)
        end

        it 'updates the account balances' do
          post '/api/v1/transactions', params: valid_params, headers: headers
          expect(user.bank_account.reload.balance).to eq(900.00)
          expect(destination_user.bank_account.reload.balance).to eq(1100.00)
        end

        it 'returns status 201' do
          post '/api/v1/transactions', params: valid_params, headers: headers
          expect(response).to have_http_status(:created)
        end
      end

      context 'with insufficient balance' do
        let(:invalid_params) do
          {
            transaction: {
              amount: 2000.00,
              destination_account_id: destination_user.bank_account.id
            }
          }
        end

        it 'does not create the transaction' do
          expect {
            post '/api/v1/transactions', params: invalid_params, headers: headers
          }.not_to change(Transaction, :count)
        end

        it 'returns status 422' do
          post '/api/v1/transactions', params: invalid_params, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'without authentication' do
      it 'returns status 401' do
        post '/api/v1/transactions', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/transactions' do
    before do
      create_list(:transaction, 3, source_account: user.bank_account)
      create_list(:transaction, 2, destination_account: user.bank_account)
    end

    context 'with authentication' do
      it 'returns the user transactions' do
        get '/api/v1/transactions', headers: headers
        expect(JSON.parse(response.body).length).to eq(5)
      end

      it 'returns status 200' do
        get '/api/v1/transactions', headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without authentication' do
      it 'returns status 401' do
        get '/api/v1/transactions'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/transactions/deposit' do
    let(:deposit_params) do
      {
        transaction: {
          amount: 200.00,
          destination_account_id: user.bank_account.id
        }
      }
    end

    context 'with authentication' do
      it 'makes a deposit to the account' do
        expect {
          post '/api/v1/transactions/deposit', params: deposit_params, headers: headers
        }.to change(Transaction, :count).by(1)
        expect(user.bank_account.reload.balance).to eq(1200.00)
      end
    end

    context 'without authentication' do
      it 'returns status 401' do
        post '/api/v1/transactions/deposit', params: deposit_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
