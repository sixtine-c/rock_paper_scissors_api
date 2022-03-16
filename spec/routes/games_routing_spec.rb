# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Games', type: :routing do
  describe 'routing' do
    it 'routes to #result' do
      expect(get: '/api/v1/games/result').to route_to('api/v1/games#result', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/games').to route_to('api/v1/games#create', format: :json)
    end
  end
end
