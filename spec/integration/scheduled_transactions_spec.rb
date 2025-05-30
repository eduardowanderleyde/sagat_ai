require 'swagger_helper'

RSpec.describe 'Scheduled Transactions API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/scheduled_transactions' do
    post 'Schedule a new transfer' do
      tags 'Scheduled Transactions'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction: {
            type: :object,
            properties: {
              amount: { type: :number, format: :float, example: 50.0 },
              destination_account_id: { type: :integer, example: 2 },
              description: { type: :string, example: 'Rent payment' },
              scheduled_for: { type: :string, format: :date_time, example: '2025-05-25T10:00:00' }
            },
            required: [ 'amount', 'destination_account_id', 'scheduled_for' ]
          }
        },
        required: [ 'transaction' ]
      }

      response '201', 'scheduled transaction created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 amount: { type: :number, format: :float },
                 status: { type: :string },
                 scheduled_for: { type: :string, format: :date_time },
                 description: { type: :string },
                 destination_account_id: { type: :integer }
               },
               required: [ 'id', 'amount', 'status', 'scheduled_for', 'description', 'destination_account_id' ]
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               },
               required: [ 'errors' ]
        run_test!
      end
    end
  end
end 