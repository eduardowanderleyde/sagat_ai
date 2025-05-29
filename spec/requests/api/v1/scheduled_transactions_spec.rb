require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Api::V1::ScheduledTransactions', type: :request do
  before { Sidekiq::Testing.fake! }

  let(:user) { create(:user, :with_bank_account) }
  let(:destination_user) { create(:user, :with_bank_account) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'POST /api/v1/transferencias/agendada' do
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

    context 'com autenticação' do
      context 'com parâmetros válidos' do
        it 'cria uma nova transação agendada' do
          expect {
            post '/api/v1/transferencias/agendada', params: valid_params, headers: headers
          }.to change(ScheduledTransaction, :count).by(1)
        end

        it 'não atualiza os saldos das contas imediatamente' do
          expect {
            post '/api/v1/transferencias/agendada', params: valid_params, headers: headers
          }.not_to change { user.bank_account.reload.balance }
        end

        it 'retorna status 201' do
          post '/api/v1/transferencias/agendada', params: valid_params, headers: headers
          expect(response).to have_http_status(:created)
        end

        it 'agenda o job para processar a transação' do
          expect {
            post '/api/v1/transferencias/agendada', params: valid_params, headers: headers
          }.to change { ProcessScheduledTransactionWorker.jobs.size }.by(1)
        end
      end

      context 'com parâmetros inválidos' do
        let(:invalid_params) do
          {
            transaction: {
              amount: 2000.00,
              destination_account_id: destination_user.bank_account.id,
              scheduled_for: 1.day.ago.iso8601
            }
          }
        end

        it 'não cria a transação agendada' do
          expect {
            post '/api/v1/transferencias/agendada', params: invalid_params, headers: headers
          }.not_to change(ScheduledTransaction, :count)
        end

        it 'retorna status 422' do
          post '/api/v1/transferencias/agendada', params: invalid_params, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'sem autenticação' do
      it 'retorna status 401' do
        post '/api/v1/transferencias/agendada', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
