# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  it 'has a name' do
    game = Game.new(
      name: '',
      move: 'rock'
    )
    expect(game).to_not be_valid
    game.name = 'John'
    expect(game).to be_valid
  end

  it 'has a move' do
    game = Game.new(
      name: 'John',
      move: ''
    )
    expect(game).to_not be_valid
    game.move = 'rock'
    expect(game).to be_valid
  end

  it 'has a valid move' do
    game = Game.new(
      name: 'John',
      move: 'spock'
    )
    expect(game).to_not be_valid
    game.move = 'rock'
    expect(game).to be_valid
  end
end
