# README

* Following the instructions of the technical test I decided to create a rails api only app, tested with Rspec.
First the player is asked to play a move. This action triggers the bot move.
Both actions are saved in the database if they meet 3 conditions.
Following the bot move, the result is calculated and rendered. The player just need to refresh the endpoint to see the result.
After the result is calculated and rendered, the games table is automatically destroyed and the game can be played again. Theefore, the results are not saved in the DB.


* Ruby version: 2.7.4 Rails version : 6.0.4.7

* clone of fork the repo

* Create the DB with following commands
  rails db:create, rails db:migrate

* How to access the API endpoint
  rails s
  localhost:3000
  OR
  http://localhost:3000/api/v1/games/result


* How to play a move
  curl -i -X POST \
      -H 'Content-Type: application/json'    \
      -d '{ "name": "your-name", "move": "your-move" }' \
      http://localhost:3000/api/v1/games

* How to get the result
  refresh localhost:3000
  OR
  http://localhost:3000/api/v1/games/result

* Testing with Rspec with command line
  rails spec
