# spec/requests/universities_spec.rb
require 'swagger_helper'

RSpec.describe 'Universities API', type: :request do
  path '/universities' do
    get 'List all universities' do
      tags 'Universities'
      produces 'application/json'

      response '200', 'universities found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   location: { type: :string }
                 },
                 required: ['id', 'name', 'location']
               }

        run_test!
      end
    end
  end

  path '/universities/{id}' do
    get 'Retrieve a university' do
      tags 'Universities'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'university found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 location: { type: :string }
               },
               required: ['id', 'name', 'location']

        let(:id) { University.create(name: 'Test University', location: 'Test Location').id }
        run_test!
      end

      response '404', 'university not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
