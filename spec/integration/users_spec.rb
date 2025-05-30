require 'swagger_helper'

RSpec.describe 'Users API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/users/{id}' do
    get 'Get user data' do
      tags 'Users'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 email: { type: :string },
                 name: { type: :string },
                 cpf: { type: :string }
               },
               required: [ 'id', 'email', 'name', 'cpf' ]
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

    patch 'Update user data' do
      tags 'Users'
      consumes 'application/json'
      security [ Bearer: [] ]
      parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string, example: 'New Name' },
              email: { type: :string, example: 'new@email.com' },
              password: { type: :string, example: 'newPassword123' }
            }
          }
        }
      }

      response '200', 'user updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 email: { type: :string },
                 name: { type: :string },
                 cpf: { type: :string }
               },
               required: [ 'id', 'email', 'name', 'cpf' ]
        run_test!
      end

      response '422', 'invalid data' do
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
