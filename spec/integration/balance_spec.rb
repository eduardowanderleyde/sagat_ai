require 'swagger_helper'

RSpec.describe 'Bank Account API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/account/balance' do
    get 'Get current user account balance' do
      tags 'Bank Account'
      produces 'application/json'
      security [ Bearer: [] ]

      response '200', 'balance returned' do
        schema type: :object,
               properties: {
                 balance: { type: :number, format: :float }
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
end
