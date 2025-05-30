require 'swagger_helper'

RSpec.describe 'Statement API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/statement' do
    get 'Get account statement with optional filters' do
      tags 'Statement'
      produces 'application/json'
      security [Bearer: []]
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