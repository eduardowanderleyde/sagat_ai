require 'swagger_helper'

RSpec.describe 'Auth API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/auth/login' do
    post 'Authenticate user and return JWT' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'authenticated' do
        schema type: :object,
               properties: {
                 token: { type: :string },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     name: { type: :string },
                     cpf: { type: :string }
                   }
                 }
               },
               required: [ 'token', 'user' ]

        let(:credentials) { { email: 'user@example.com', password: 'password123' } }
        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               },
               required: [ 'error' ]

        let(:credentials) { { email: 'user@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end
end 