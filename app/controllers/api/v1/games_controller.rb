# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      def create
        @game_player = Game.new(game_params)
        if @game_player.valid?
          create_bot_move
          find_winner
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

      def create_bot_move
        @game_bot = Game.new(name: 'Bot',
                             move: %w[rock paper scissors].sample)
      end

      def find_winner
        winning_moves = {
          'rock' => 'scissors',
          'scissors' => 'paper',
          'paper' => 'rock'
        }
        tie = @game_player.move == @game_bot.move
        winner = if tie == true
                   "There's no winner here!"
                 else
                   winning_moves[@game_player.move] == @game_bot.move ? @game_player.name : @game_bot.name
                 end
        create_results(winner, tie)
      end

      def create_results(winner, tie)
        @result = {
          "moves": [
            {
              name: @game_player.name,
              move: @game_player.move
            },
            {
              name: @game_bot.name,
              move: @game_bot.move
            }
          ],
          "result": {
            tie: tie,
            winner: winner
          }
        }
      end

      def render_error
        render json: JSON.pretty_generate({ errors: @game_player.errors.each { |v| puts "#{v}"}}),
               status: :bad_request
      end
    end
  end
end
