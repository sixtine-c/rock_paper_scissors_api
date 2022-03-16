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

  let(:tie_attributes_player) do
    {
      'name' => 'Emily',
      'move' => 'scissors'
    }
  end

  let(:valid_attributes_bot) do
    {
      'name' => 'bot',
      'move' => 'paper'
    }
  end

  let(:tie_attributes_bot) do
    {
      'name' => 'bot',
      'move' => 'scissors'
    }
  end

  let(:create_winning_game) do
    Game.create(valid_attributes_player)
    Game.create(valid_attributes_bot)
    @moves = []
    @games = Game.all
    @games.each do |game|
      @moves << game
    end
  end

  let(:create_tie_game) do
    Game.create(tie_attributes_player)
    Game.create(tie_attributes_bot)
    @moves = []
    @games = Game.all
    @games.each do |game|
      @moves << game
    end
  end

  describe 'GET /result' do
    it 'returns http success' do
      create_winning_game
      get '/api/v1/games/result'

      expect(response).to have_http_status(:created)
    end

    it 'returns a game result with a winner name' do
      create_winning_game
      get '/api/v1/games/result'

      json = JSON.parse(response.body)
      expect(json['result']).to_not be_nil
      expect(json['result']['winner']).to eq('bot')
    end

    it 'returns a tie game' do
      create_tie_game
      get '/api/v1/games/result'

      json = JSON.parse(response.body)
      expect(json['result']['tie']).to eq(true)
      expect(json['result']['winner']).to eq("There's no winner here!")
    end
  end

  describe 'POST /games' do
    scenario 'valid games attributes' do
      expect do
        post '/api/v1/games', params: { 'game' => valid_attributes_player }
      end.to change { Game.count }.from(0).to(1)

      expect(response).to have_http_status(:success)
    end

    scenario 'invalid bookmark attributes' do
      post '/api/v1/games', params: { 'game' => invalid_attributes_player }

      expect(response.status).to eq(422)
      expect(Game.count).to eq(0)
    end
  end
end
