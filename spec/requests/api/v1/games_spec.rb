# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Games', type: :request do
  let(:valid_attributes_player) do
    {
      'name' => 'John',
      'move' => 'rock'
    }
  end

  let(:invalid_attributes_player) do
    {
      'name' => '',
      'move' => 'rock'
    }
  end

  describe 'POST /games' do
    scenario 'valid game attributes' do
      post '/api/v1/games', params: { 'game' => valid_attributes_player }

      expect(response).to have_http_status(:success)
    end

    scenario 'invalid game attributes' do
      post '/api/v1/games', params: { 'game' => invalid_attributes_player }

      expect(response.status).to eq(400)
    end

    it 'returns a game result in the JSON response' do
      post '/api/v1/games', params: { 'game' => valid_attributes_player }

      json = JSON.parse(response.body)
      expect(json['result']).to_not be_nil

      winning_moves = {
        'rock' => 'scissors',
        'scissors' => 'paper',
        'paper' => 'rock'
      }

      if json['moves'].first['move'] == json['moves'].last['move']
        expect(json['result']['tie']).to eq(true)
        expect(json['result']['winner']).to eq("There's no winner here!")
      elsif winning_moves[json['moves'].first['move']] == json['moves'].last['move']
        expect(json['result']['winner']).to eq('John')
      else
        expect(json['result']['winner']).to eq('Bot')
      end
    end
  end
end
