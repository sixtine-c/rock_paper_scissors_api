# README

## Introduction

* Following the instructions of the technical test I decided to create a rails api only app, tested with Rspec.
First the player is asked to play a move. This action triggers the bot move.
Both actions are saved in the database if they meet 3 conditions.
Following the bot move, the result is calculated and rendered. The player just need to refresh the endpoint to see the result.
After the result is calculated and rendered, the games table is automatically destroyed and the game can be played again. Therefore, the results are not saved in the DB.

## Installation

* Ruby version: 2.7.4 Rails version : 6.0.4.7

* clone or fork the repo : https://github.com/sixtine-c/rock_paper_scissors_api

* please don't forget to bundle:

  ```bash
    bundle install
  ```

* Create the DB with following commands:
  ```bash
    rails db:create
    rails db:migrate
  ```

* Launch the server:
   ```bash
    rails s
  ```
* Access the API Endpoint: \
  http://localhost:3000 \
  OR \
  http://localhost:3000/api/v1/games/result

## Play the game

* How to play a move:
  ```bash
    curl -i -X POST \
      -H 'Content-Type: application/json'    \
      -d '{ "name": "your-name", "move": "your-move" }' \
      http://localhost:3000/api/v1/games
  ```

* How to get the result: \
  Refresh http://localhost:3000
  OR
  http://localhost:3000/api/v1/games/result

* Testing with Rspec with command line:
  ```bash
    rails spec
  ```
