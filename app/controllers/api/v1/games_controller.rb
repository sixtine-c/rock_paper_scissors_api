# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      after_action :destroy_previous_game, only: :create

      def create
        @game = Game.new(game_params)
        if @game.save
          create_bot_move
          result
          render json: JSON.pretty_generate(@result), status: :created
        else
          render_error
        end
      end

      def index
        @intro = "Welcome to 'Rock - paper - scissors', make a move to play =>
        curl -i -X POST -H 'Content-Type: application/json' -d '{ 'name': 'Your name', 'move': 'rock, paper or scissors' }' http://localhost:3000/api/v1/games"
        render json: @intro
      end

      private

      def game_params
        params.require(:game).permit(:name, :move)
      end

      def destroy_previous_game
        Game.destroy_all
      end

      def create_bot_move
        Game.create!(name: 'Bot',
                     move: %w[rock paper scissors].sample)
      end

      def result
        @games = Game.all
        @moves = []
        @games.each do |game|
          @moves << game
        end
        find_winner
        @result
      end

      def find_winner
        winning_moves = {
          'rock' => 'scissors',
          'scissors' => 'paper',
          'paper' => 'rock'
        }
        tie = @moves.first.move == @moves.last.move
        winner = if tie == true
                   "There's no winner here!"
                 else
                   winning_moves[@moves.first.move] == @moves.last.move ? @moves.first.name : @moves.last.name
                 end
        create_results(winner, tie)
      end

      def create_results(winner, tie)
        @result = {
          "moves": [
            {
              name: @moves.first.name,
              move: @moves.first.move
            },
            {
              name: @moves.last.name,
              move: @moves.last.move
            }
          ],
          "result": {
            tie: tie,
            winner: winner
          }
        }
      end

      def render_error
        render json: { errors: @game.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  end
end
