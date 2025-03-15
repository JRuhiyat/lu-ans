require './game.rb'
require './random_player.rb'
require './your_player.rb'
require './helper.rb'

srand(129)

grid_size = 5

your_strategy = -> {
  game = Game.new(grid_size: grid_size)

  p1 = YourPlayer.new(game: game, name: 'Player 1')
  p2 = YourPlayer.new(game: game, name: 'Player 2')

  game.add_player(p1)
  game.add_player(p2)

  game.start
}

random_strategy = -> {
  game = Game.new(grid_size: grid_size)

  random_player = RandomPlayer.new(game: game, name: 'Rando 1')
  random_player2 = RandomPlayer.new(game: game, name: 'Rando 2')

  game.add_player(random_player)
  game.add_player(random_player2)

  game.start
}

random_results = random_strategy.call
your_results = your_strategy.call

compare_hashes(your_results, random_results)
