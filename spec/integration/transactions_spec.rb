require 'swagger_helper'

RSpec.describe 'Transactions API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/transactions' do
    post 'Create a new transfer transaction' do
      tags 'Transactions'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction: {
            type: :object,
            properties: {
              amount: { type: :number, format: :float, example: 100.0 },
              destination_account_id: { type: :integer, example: 2 },
              description: { type: :string, example: 'Transfer payment' }
            },
            required: [ 'amount', 'destination_account_id' ]
          }
        },
        required: [ 'transaction' ]
      }

      response '201', 'transaction created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 amount: { type: :number, format: :float },
                 transaction_type: { type: :string },
                 status: { type: :string },
                 description: { type: :string },
                 destination_account_id: { type: :integer }
               },
               required: [ 'id', 'amount', 'transaction_type', 'status', 'description', 'destination_account_id' ]
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