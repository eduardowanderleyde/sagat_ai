require 'swagger_helper'

RSpec.describe 'Bank Accounts API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/bank_accounts/{id}' do
    get 'Get user bank account' do
      tags 'Bank Account'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :id, in: :path, type: :integer, required: true, description: 'Bank Account ID'

      response '200', 'bank account found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 account_number: { type: :string, example: 'A1B2C3D4' },
                 agency: { type: :string, example: '1234' },
                 balance: { type: :number, format: :float, example: 1000.0 }
               },
               required: [ 'id', 'account_number', 'agency', 'balance' ]
        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               },
               required: [ 'error' ]
        run_test!
      end
    end
  end

  path '/api/v1/bank_accounts/{id}/balance' do
    get 'Get balance for a specific bank account' do
      tags 'Bank Account'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :id, in: :path, type: :integer, required: true, description: 'Bank Account ID'

      response '200', 'balance returned' do
        schema type: :object,
               properties: {
                 balance: { type: :number, format: :float, example: 1000.0 }
               },
               required: [ 'balance' ]
        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               },
               required: [ 'error' ]
        run_test!
      end
    end
  end

  path '/api/v1/bank_accounts/{id}/statement' do
    get 'Get statement for a specific bank account' do
      tags 'Bank Account'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :id, in: :path, type: :integer, required: true, description: 'Bank Account ID'
      parameter name: :start_date, in: :query, type: :string, format: :date, required: false, description: 'Start date filter'
      parameter name: :end_date, in: :query, type: :string, format: :date, required: false, description: 'End date filter'
      parameter name: :min_amount, in: :query, type: :number, format: :float, required: false, description: 'Minimum amount filter'
      parameter name: :type, in: :query, type: :string, required: false, description: 'Transaction type filter'

      response '200', 'statement returned' do
        schema type: :object,
               properties: {
                 transactions: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       amount: { type: :number, format: :float },
                       transaction_type: { type: :string },
                       status: { type: :string },
                       created_at: { type: :string, format: :date_time }
                     }
                   }
                 },
                 current_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer }
               },
               required: [ 'transactions', 'current_page', 'total_pages', 'total_count' ]
        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               },
               required: [ 'error' ]
        run_test!
      end
    end
  end
end
