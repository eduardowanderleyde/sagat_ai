require 'swagger_helper'

RSpec.describe 'Auth API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/auth/register' do
    post 'Registers a new user' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' },
              name: { type: :string, example: 'Test User' },
              cpf: { type: :string, example: '52998224725' }
            },
            required: [ 'email', 'password', 'name', 'cpf' ]
          }
        },
        required: [ 'user' ]
      }

      response '201', 'user created' do
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

        let(:user) { { user: { email: 'user@example.com', password: 'password123', name: 'Test User', cpf: '52998224725' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               },
               required: [ 'errors' ]

        let(:user) { { user: { email: '', password: '', name: '', cpf: '' } } }
        run_test!
      end
    end
  end
end 