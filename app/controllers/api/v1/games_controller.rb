# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      after_action :destroy_previous_game, only: :result

      def create
        @game = Game.new(game_params)
        if @game.save
          create_computer_move if @game.name != 'Bot'

          render :result

        else
          render_error
        end
      end

      def result
        @games = Game.all

        if @games.empty?
          @result = "Welcome to 'Rock - paper - scissors', make a move to play =>
          curl -i -X POST -H 'Content-Type: application/json' -d '{ 'name': 'Your name', 'move': 'rock, paper or scissors' }' http://localhost:3000/api/v1/games"
          render json: @result
        else
          @moves = []
          @games.each do |game|
            @moves << game
          end

          find_winner
          render json: @result, status: :created, location: @result
        end
      end

      private

      def destroy_previous_game
        Game.destroy_all
      end

      def create_computer_move
        require 'uri'
        require 'net/http'
        require 'json'

        uri = URI('http://localhost:3000/api/v1/games')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        req.body = { name: 'Bot', move: %w[rock paper scissors].sample }.to_json
        http.request(req)
        puts req.body
      end

      def game_params
        params.require(:game).permit(:name, :move)
      end

      def render_error
        render json: { errors: @game.errors.full_messages },
               status: :unprocessable_entity
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
    end
  end
end
