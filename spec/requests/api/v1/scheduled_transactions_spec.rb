require "rails_helper"
require "sidekiq/testing"

RSpec.describe "Api::V1::ScheduledTransactions", type: :request do
  before { Sidekiq::Testing.fake! }

  let(:user) { create(:user, :with_bank_account) }
  let(:destination_user) { create(:user, :with_bank_account) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'POST /api/v1/scheduled_transactions' do
    let(:valid_params) do
      {
        transaction: {
          amount: 100.00,
          destination_account_id: destination_user.bank_account.id,
          description: 'Pagamento aluguel',
          scheduled_for: 1.day.from_now.iso8601
        }
      }
    end

    context 'with authentication' do
      context 'with valid parameters' do
        it 'creates a new scheduled transaction' do
          expect {
            post '/api/v1/scheduled_transactions', params: valid_params, headers: headers
          }.to change(ScheduledTransaction, :count).by(1)
        end

        it 'does not update the account balances immediately' do
          expect {
            post '/api/v1/scheduled_transactions', params: valid_params, headers: headers
          }.not_to change { user.bank_account.reload.balance }
        end

        it 'returns status 201' do
          post '/api/v1/scheduled_transactions', params: valid_params, headers: headers
          expect(response).to have_http_status(:created)
        end

        it 'schedules the job to process the transaction' do
          expect {
            post '/api/v1/scheduled_transactions', params: valid_params, headers: headers
          }.to change { ProcessScheduledTransactionWorker.jobs.size }.by(1)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          {
            transaction: {
              amount: 2000.00,
              destination_account_id: destination_user.bank_account.id,
              scheduled_for: 1.day.ago.iso8601
            }
          }
        end

        it 'does not create the scheduled transaction' do
          expect {
            post '/api/v1/scheduled_transactions', params: invalid_params, headers: headers
          }.not_to change(ScheduledTransaction, :count)
        end

        it 'returns status 422' do
          post '/api/v1/scheduled_transactions', params: invalid_params, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'without authentication' do
      it 'returns status 401' do
        post '/api/v1/scheduled_transactions', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
